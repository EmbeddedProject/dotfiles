#!/usr/bin/env python3

import argparse
import re
import subprocess
import sys
import time


KEYCODES = {
    9: 'Esc',
    10: '&',
    11: 'é',
    12: '"',
    13: "'",
    14: '(',
    15: '-',
    16: 'è',
    17: '_',
    18: 'ç',
    19: 'à',
    20: ')',
    21: '=',
    22: 'BackSpace',
    23: 'Tab',
    24: 'a',
    25: 'z',
    26: 'e',
    27: 'r',
    28: 't',
    29: 'y',
    30: 'u',
    31: 'i',
    32: 'o',
    33: 'p',
    34: '^',
    35: '$',
    36: 'Return',
    38: 'q',
    39: 's',
    40: 'd',
    41: 'f',
    42: 'g',
    43: 'h',
    44: 'j',
    45: 'k',
    46: 'l',
    47: 'm',
    48: 'ù',
    49: '@',
    51: '*',
    52: 'w',
    53: 'x',
    54: 'c',
    55: 'v',
    56: 'b',
    57: 'n',
    58: ',',
    59: ';',
    60: ':',
    61: '!',
    63: 'Kp*',
    65: 'Space',
    67: 'F1',
    68: 'F2',
    69: 'F3',
    70: 'F4',
    71: 'F5',
    72: 'F6',
    73: 'F7',
    74: 'F8',
    75: 'F9',
    76: 'F10',
    77: 'NumLock',
    78: 'ScrollLock',
    79: 'Kp7',
    80: 'Kp8',
    81: 'Kp9',
    82: 'Kp-',
    83: 'Kp4',
    84: 'Kp5',
    85: 'Kp6',
    86: 'Kp+',
    87: 'Kp1',
    88: 'Kp2',
    89: 'Kp3',
    90: 'Kp0',
    91: 'Kp.',
    94: '<',
    95: 'F11',
    96: 'F12',
    104: 'KpEnter',
    106: 'Kp/',
    107: 'PrintScreen',
    110: 'Home',
    111: 'Up',
    112: 'PgUp',
    113: 'Left',
    114: 'Right',
    115: 'End',
    116: 'Down',
    117: 'PgDown',
    118: 'Ins',
    119: 'Del',
    127: 'Break',
}

MODIFIERS = {
    37,  # Ctrl
    50,  # Shift
    62,  # Shift
    64,  # Alt
    105,  # Ctrl
    108,  # AltGr
    133,  # Win
}

SHIFTED = {
    10: '1',
    11: '2',
    12: '3',
    13: '4',
    14: '5',
    15: '6',
    16: '7',
    17: '8',
    18: '9',
    19: '0',
    20: '°',
    21: '+',
    24: 'A',
    25: 'Z',
    26: 'E',
    27: 'R',
    28: 'T',
    29: 'Y',
    30: 'U',
    31: 'I',
    32: 'O',
    33: 'P',
    34: '"',
    35: '`',
    38: 'Q',
    39: 'S',
    40: 'D',
    41: 'F',
    42: 'G',
    43: 'H',
    44: 'J',
    45: 'K',
    46: 'L',
    47: 'M',
    48: '%',
    51: '\\',
    52: 'W',
    53: 'X',
    54: 'C',
    55: 'V',
    56: 'B',
    57: 'N',
    58: '?',
    59: '.',
    60: '/',
    61: '|',
    94: '>',
}

ALTGR = {
    11: '~',
    12: '#',
    13: '{',
    14: '[',
    15: '|',
    16: '`',
    17: '\\',
    18: '^',
    19: '@',
    20: ']',
    21: '}',
}

XINPUT_RE = re.compile(r'^key\s+(press|release)\s+(\d+)$')

def get_keyboard_id(name):
    out = subprocess.check_output(['xinput', '--list']).decode()
    match = re.search(rf'{name}\s+id=(\d+)', out)
    if not match:
        raise FileNotFoundError(f'no such keyboard: {name}')
    return match.group(1)


class KeyPress:

    def __init__(self, timestamp, ctrl, alt, shift, altgr, win, keynum):
        self.timestamp = timestamp
        self.ctrl = ctrl
        self.alt = alt
        self.shift = shift
        self.altgr = altgr
        self.win = win
        self.keynum = keynum

    @classmethod
    def from_keypress(cls, modifiers, keynum):
        return cls(
            timestamp=time.time(),
            ctrl=37 in modifiers,
            alt=64 in modifiers,
            shift=50 in modifiers or 62 in modifiers,
            altgr=108 in modifiers,
            win=133 in modifiers,
            keynum=keynum,
        )

    @classmethod
    def from_tsv(cls, line):
        tokens = line.strip().split('\t')
        return cls(
            timestamp=float(tokens[0]),
            ctrl=bool(int(tokens[1])),
            alt=bool(int(tokens[2])),
            shift=bool(int(tokens[3])),
            altgr=bool(int(tokens[4])),
            win=bool(int(tokens[5])),
            keynum=int(tokens[6]),
        )

    def to_tsv(self):
        tokens = [
            f'{self.timestamp:.03f}',
            '1' if self.ctrl else '0',
            '1' if self.alt else '0',
            '1' if self.shift else '0',
            '1' if self.altgr else '0',
            '1' if self.win else '0',
            str(self.keynum),
        ]
        return '\t'.join(tokens)

    def __str__(self):
        tokens = []
        if self.ctrl:
            tokens.append('Ctrl')
        if self.alt:
            tokens.append('Alt')
        if self.shift:
            tokens.append('Shift')
        if self.altgr:
            tokens.append('AltGr')
        tokens.append(KEYCODES[self.keynum])
        if self.shift and self.keynum in SHIFTED:
            tokens.append(f'({SHIFTED[self.keynum]})')
        elif self.altgr and self.keynum in ALTGR:
            tokens.append(f'({ALTGR[self.keynum]})')
        return ' '.join(tokens)

    def __hash__(self):
        return hash((
            self.timestamp, self.ctrl, self.alt, self.shift,
            self.altgr, self.win, self.keynum))

    def __eq__(self, other):
        return isinstance(other, type(self)) and \
           other.timestamp == self.timestamp and \
           other.ctrl == self.ctrl and \
           other.alt == self.alt and \
           other.shift == self.shift and \
           other.altgr == self.altgr and \
           other.win == self.win and \
           other.keynum == self.keynum


def dump_stats(f):
    presses = []
    for line in f.readlines():
        k = KeyPress.from_tsv(line.strip())
        presses.append(k)
        print(k)








def dump_keypress(modifiers, keynum, f):
    k = KeyPress.from_keypress(modifiers, keynum)
    f.write(k.to_tsv() + '\n')
    f.flush()


def main():
    parser = argparse.ArgumentParser(
        description='''
        Analyze keyboard usage statistics.
        ''')
    parser.add_argument(
        'file',
        nargs='?',
        default='-',
        help='''
        File where to dump/read keyboard events. The following fields are tab
        separated: timestamp, ctrl, alt, shift, altgr, win, key number,
        symbol/action.
        ''')
    parser.add_argument(
        '-k', '--keyboard-name',
        help='''
        The keyboard name to lookup its device ID from xinput.
        ''')
    parser.add_argument(
        '-s', '--statistics',
        action='store_true',
        help='''
        Parse keyboard events from file and display key combinations usage
        statistics.
        ''')

    args = parser.parse_args()

    if args.statistics:
        if args.file == '-':
            f = sys.stdin
        else:
            f = open(args.file, 'r')
        return dump_stats(f)

    if args.keyboard_name is None:
        parser.error('-k, --keyboard-name not specified')

    device_id = get_keyboard_id(args.keyboard_name)
    proc = subprocess.Popen(
        ['xinput', '--test', device_id],
        stdout=subprocess.PIPE, stdin=subprocess.DEVNULL)

    if args.file == '-':
        f = sys.stdout
    else:
        f = open(args.file, 'a')

    mods = set()

    while True:
        try:
            if proc.poll() is not None:
                break
            line = proc.stdout.readline().decode()
            match = XINPUT_RE.match(line.strip())
            if match:
                action = match.group(1)
                keynum = int(match.group(2))
                if keynum in MODIFIERS:
                    if action == 'press':
                        mods.add(keynum)
                    else:
                        mods.discard(keynum)
                elif action == 'press' and keynum in KEYCODES:
                    dump_keypress(mods, keynum, f)
        except (BrokenPipeError, KeyboardInterrupt):
            proc.terminate()
            proc.wait()
            f.flush()
            f.close()
            break


if __name__ == '__main__':
    main()
