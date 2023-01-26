#!/usr/bin/env python3

import asyncio
import json
import signal
import sys

from i3ipc.aio import Connection


last_data = None


def get_chats(tree):
    for window in tree:
        if window.window_class == 'Hexchat':
            yield window
        elif getattr(window, 'app_id', None) == 'weechat':
            yield window


def is_chat(container):
    if container.app_id == 'weechat':
        return True
    if container.window_class == 'Hexchat':
        return True
    return False


async def refresh_block(i3, event=None, tree=None):
    global last_data
    running = urgent = False

    if tree is not None:
        for c in get_chats(tree):
            running = True
            urgent |= c.urgent

    elif event is not None and is_chat(event.container):
        if event.change == 'new':
            running = True
        elif event.change == 'urgent':
            running = True
            urgent = event.container.urgent

    else:
        return

    data = {'text': '\uf075 chat'}

    if running:
        if urgent:
            data['class'] = 'urgent'
    else:
        data['class'] = 'disabled'

    if data != last_data:
        last_data = data
        sys.stdout.write(f'{json.dumps(data)}\n')
        sys.stdout.flush()


async def main():
    i3 = Connection()
    await i3.connect()
    tree = await i3.get_tree()
    await refresh_block(i3, event=None, tree=tree)
    i3.on('window::new', refresh_block)
    i3.on('window::close', refresh_block)
    i3.on('window::urgent', refresh_block)
    loop = asyncio.get_event_loop()
    loop.add_signal_handler(signal.SIGINT, i3.main_quit)
    loop.add_signal_handler(signal.SIGTERM, i3.main_quit)
    loop.add_signal_handler(signal.SIGQUIT, i3.main_quit)
    await i3.main()


if __name__ == '__main__':
    asyncio.run(main())
