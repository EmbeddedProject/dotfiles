#!/usr/bin/env python

__module_name__ = 'auto_away'
__module_version__ = '1'
__module_description__ = 'set away when screensaver is running (linux only)'
__author__ = 'Robin Jarry'

import xchat
import shlex
import subprocess

NICK = xchat.get_info('nick')
OFF_NICK = NICK + '_off'

def exec_cmd(cmd, **popenargs):
    try:
        process = subprocess.Popen(shlex.split(cmd),
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT,
                                   **popenargs)
    except os.error as e:
        return str(e)

    stdout, _ = process.communicate()
    process.wait()

    return stdout

def auto_away(userdata):
    is_away = xchat.get_info('away')

    out = exec_cmd('xset q')

    if 'Monitor is On' in out:
        if is_away:
            xchat.command('BACK')
            xchat.command('NICK %s' % NICK)
    elif 'Monitor is in Standby' in out or 'Monitor is in Suspend' in out:
        if not is_away:
            xchat.command('AWAY afk')

    elif 'Monitor is Off' in out:
        if xchat.get_info('nick') != OFF_NICK:
            xchat.command('NICK %s' % OFF_NICK)
            xchat.command('AWAY vfafk')

    return 1

xchat.hook_timer(3000, auto_away)

print 'Loaded %s plugin' % __module_name__
