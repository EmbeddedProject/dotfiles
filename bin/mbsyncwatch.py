#!/usr/bin/env python3

import argparse
import asyncio
import logging
import pathlib
import re
import shlex
import signal
import subprocess
import sys

import aionotify
import aioimaplib


LOG = logging.getLogger()


async def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-a",
        "--all",
        action="store_true",
        help=argparse.SUPPRESS,
    )
    parser.add_argument(
        "-c",
        "--config",
        default=pathlib.Path("~/.mbsyncrc").expanduser(),
        type=pathlib.Path,
        help="""
        Read configuration from file.
        By default, the configuration is read from ~/.mbsyncrc.
        """,
    )
    parser.add_argument(
        "channel",
        metavar="CHANNEL",
        help="The mbsync channel or group to watch and sync.",
    )
    parser.add_argument(
        "mbsync_opts",
        nargs=argparse.REMAINDER,
        metavar="...",
        help="Other mbsync options.",
    )
    args = parser.parse_args()

    if args.all:
        parser.error("-a/--all is not supported")

    logging.basicConfig(
        stream=sys.stdout,
        level=logging.INFO,
        format="%(asctime)s %(levelname)-5s %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )

    def shutdown():
        for t in asyncio.all_tasks():
            t.cancel()

    loop = asyncio.get_running_loop()
    loop.add_signal_handler(signal.SIGTERM, shutdown)
    loop.add_signal_handler(signal.SIGINT, shutdown)

    try:
        await run_mbsync(args)
    except asyncio.CancelledError:
        return

    backoff = 5

    while True:
        try:
            await wait_change(args)
            await run_mbsync(args)
            backoff = 5
        except asyncio.CancelledError:
            break
        except Exception as err:
            LOG.exception(
                "unexpected error %s, waiting %ss before retry",
                err,
                backoff
            )
            await asyncio.sleep(backoff)
            backoff = min(backoff * 2, 300)


async def run_mbsync(args):
    cmd = ["mbsync", "-c", str(args.config)] + args.mbsync_opts + [args.channel]
    LOG.info("running %r", " ".join(cmd))
    proc = subprocess.Popen(cmd)
    loop = asyncio.get_running_loop()
    try:
        await loop.run_in_executor(None, proc.wait)
    finally:
        if proc.poll() is None:
            proc.terminate()
            await loop.run_in_executor(None, proc.wait, 0.5)
        if proc.poll() is None:
            proc.kill()
            await loop.run_in_executor(None, proc.wait, 0.5)
    if proc.returncode != 0:
        raise subprocess.CalledProcessError(proc.returncode, cmd)


STORE_DIR_RE = re.compile(r"^:([^:]+):(.*)")


async def wait_change(args):
    config = load_config(args.config)
    if args.channel in config["group"]:
        channels = config["group"][args.channel]
    else:
        channels = [args.channel]

    imap = None
    local_dirs = []
    remote_dirs = []

    for c in channels:
        chan = config["channel"][c]
        for side in ("Master", "Slave"):
            store, dirname = STORE_DIR_RE.match(chan[side]).groups()
            if dirname == "":
                dirname = "INBOX"
            store = config["store"][store]
            if "account" in store:
                imap = config["account"][store["account"]]
                remote_dirs.append(dirname)
            else:
                local_dirs.append(pathlib.Path(store["Path"]).expanduser() / dirname)

    tasks = [
        asyncio.create_task(
            wait_imap_message(
                imap["Host"],
                imap["User"],
                imap["Pass"],
                remote_dirs
            )
        ),
        asyncio.create_task(wait_maildir_change(local_dirs)),
    ]
    done, pending = await asyncio.wait(tasks, return_when=asyncio.FIRST_COMPLETED)

    for p in pending:
        p.cancel()
    for d in done:
        d.result()  # raise exception if any


async def wait_imap_message(host, user, password, remote_dirs):
    LOG.info("connecting to imap server %s", host)
    client = aioimaplib.IMAP4_SSL(host)
    conn_lost = asyncio.get_running_loop().create_future()
    client.protocol.conn_lost_cb = lambda err: conn_lost.set_exception(err)
    try:
        await client.wait_hello_from_server()
        await client.login(user, password)
        await client.select()
        LOG.info("connected to imap server %s, starting IDLE", host)
        while True:
            idle_task = await client.idle_start()
            try:
                await client.wait_server_push()
                LOG.info("imap server push event, ending IDLE")
                break
            except asyncio.TimeoutError:
                LOG.info("no imap event after 29 minutes, ending IDLE")
                break
            finally:
                client.idle_done()
                await idle_task
        await client.logout()
    finally:
        if (
            client.protocol.transport is not None and
            not client.protocol.transport.is_closing()
        ):
            client.protocol.transport.close()


async def wait_maildir_change(local_dirs):
    LOG.info("watching local dirs for changes")
    watcher = aionotify.Watcher()
    for d in local_dirs:
        for mbox in ("new", "cur"):
            watcher.watch(
                str(d / mbox),
                aionotify.Flags.CREATE | aionotify.Flags.DELETE,
            )
    try:
        await watcher.setup(asyncio.get_running_loop())
        event = await watcher.get_event()
        LOG.info("local change in %s", event.alias)
    finally:
        if not watcher.closed:
            watcher.close()


def load_config(path: pathlib.Path) -> dict:
    lines = path.read_text().splitlines()

    def next_cmd():
        while lines:
            line = lines.pop(0)
            tokens = shlex.split(line, comments=True)
            if len(tokens) != 2:
                continue
            return tokens
        return [None, None]

    config = {}

    cmd, arg = next_cmd()
    while cmd:
        if cmd == "IMAPAccount":
            name = arg
            account = {}
            cmd, arg = next_cmd()
            while cmd:
                if cmd in ("Host", "SSLType", "AuthMechs", "User", "Pass"):
                    account[cmd] = arg
                    cmd, arg = next_cmd()
                else:
                    break
            config.setdefault("account", {})[name] = account

        elif cmd == "IMAPStore":
            name = arg
            cmd, arg = next_cmd()
            if cmd != "Account":
                raise ValueError()
            config.setdefault("store", {})[name] = {"account": arg}
            cmd, arg = next_cmd()

        elif cmd == "MaildirStore":
            name = arg
            store = {}
            cmd, arg = next_cmd()
            while cmd:
                if cmd in ("Path", "Inbox"):
                    store[cmd] = arg
                    cmd, arg = next_cmd()
                else:
                    break
            config.setdefault("store", {})[name] = store

        elif cmd == "Channel":
            name = arg
            channel = {}
            cmd, arg = next_cmd()
            while cmd:
                if cmd in ("Master", "Slave", "Patterns"):
                    channel[cmd] = arg
                    cmd, arg = next_cmd()
                else:
                    break
            config.setdefault("channel", {})[name] = channel

        elif cmd == "Group":
            name = arg
            group = []
            cmd, arg = next_cmd()
            while cmd == "Channel":
                group.append(arg)
                cmd, arg = next_cmd()
            config.setdefault("group", {})[name] = group

        else:
            cmd, arg = next_cmd()

    return config


if __name__ == "__main__":
    asyncio.run(main())
