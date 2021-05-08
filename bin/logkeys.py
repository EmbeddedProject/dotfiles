#!/usr/bin/env python3

import re
import subprocess
import sys


KEYCODES = {
    9: '<Esc>',
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
    22: '<BackSpace>',
    23: '<Tab>',
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
    36: '<Return>',
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
    63: '<Kp*>',
    65: '<Space>',
    67: '<F1>',
    68: '<F2>',
    69: '<F3>',
    70: '<F4>',
    71: '<F5>',
    72: '<F6>',
    73: '<F7>',
    74: '<F8>',
    75: '<F9>',
    76: '<F10>',
    77: '<NumLock>',
    78: '<ScrollLock>',
    79: '<Kp7>',
    80: '<Kp8>',
    81: '<Kp9>',
    82: '<Kp->',
    83: '<Kp4>',
    84: '<Kp5>',
    85: '<Kp6>',
    86: '<Kp+>',
    87: '<Kp1>',
    88: '<Kp2>',
    89: '<Kp3>',
    90: '<Kp0>',
    91: '<Kp.>',
    94: '<',
    95: '<F11>',
    96: '<F12>',
    104: '<KpEnter>',
    106: '<Kp/>',
    107: '<PrintScreen>',
    110: '<Home>',
    111: '<Up>',
    112: '<PgUp>',
    113: '<Left>',
    114: '<Right>',
    115: '<End>',
    116: '<Down>',
    117: '<PgDown>',
    118: '<Ins>',
    119: '<Del>',
    127: '<Break>',
}

MODIFIERS = {
    37: '<Ctrl>',
    50: '<Shift>',
    62: '<Shift>',
    64: '<Alt>',
    105: '<Ctrl>',
    108: '<AltGr>',
    133: '<Win>',
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


def main():
    mods = set()

    out = subprocess.check_output(['xinput', '--list']).decode()
    match = re.search(r'AT Translated Set 2 keyboard\s+id=(\d+)', out)
    device_id = match.group(1)
    proc = subprocess.Popen(
        ['xinput', '--test', device_id],
        stdout=subprocess.PIPE, stdin=subprocess.DEVNULL)

    if len(sys.argv) > 1:
        f = open(sys.argv[1], 'a')
    else:
        f = sys.stdout

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
                    if mods:
                        keys = [MODIFIERS[m] for m in mods]
                        keys.append(KEYCODES[keynum])
                        if mods in ({50}, {62}) and keynum in SHIFTED:
                            keys.extend(['-------', SHIFTED[keynum]])
                        elif mods == {108} and keynum in ALTGR:
                            keys.extend(['-------', ALTGR[keynum]])
                        f.write(f'{" ".join(keys)}\n')
                    else:
                        f.write(f'{KEYCODES[keynum]}\n')
                    f.flush()
        except (BrokenPipeError, KeyboardInterrupt):
            proc.terminate()
            proc.wait()
            f.flush()
            f.close()
            break


if __name__ == '__main__':
    main()
