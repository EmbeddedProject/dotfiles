#!/usr/bin/env python3

import asyncio
import signal
import sys

from i3ipc.aio import Connection


last_text = None


async def refresh_block(i3, event=None, tree=None):
    global last_text
    running = urgent = False

    if tree is not None:
        irc = tree.find_classed('Hexchat')
        if irc:
            running = True
            urgent = any(i.urgent for i in irc)

    elif event is not None and event.container.window_class == 'Hexchat':
        if event.change == 'new':
            running = True
        elif event.change == 'urgent':
            running = True
            urgent = event.container.urgent

    else:
        return

    if running:
        if urgent:
            text = '%{F#f22}\uf075 irc%{F-}'
        else:
            text = '\uf075 irc'
    else:
        text = '%{F#888}\uf075 irc%{F-}'

    if text != last_text:
        last_text = text
        sys.stdout.write(f'{text}\n')
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
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
