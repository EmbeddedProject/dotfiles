#!/usr/bin/env python3

import argparse
import collections
import json
import os
import re
import subprocess
import sys
import time


MODIFIERS = {
    37: 'Ctrl',
    50: 'Shift',
    62: 'Shift',
    64: 'Alt',
    105: 'Ctrl',
    108: 'AltGr',
    133: 'Win',
}


class KeyMap:

    def __init__(self, filename):
        self.maps = self._parse_keymap_file(filename)

    def _parse_keymap_file(self, filename):
        maps = {}
        with open(filename, 'r') as f:
            lines = f.readlines()
        for line in lines:
            tokens = line.strip().split()
            if len(tokens) == 2:
                keynum, symbol = tokens
                modifiers = frozenset()
            elif len(tokens) == 3:
                keynum, symbol, modifier = tokens
                modifiers = frozenset([modifier])
            else:
                continue
            maps[(modifiers, int(keynum))] = symbol
        return maps

    def get_symbol(self, keynum, modifiers):
        raw = self.maps.get((frozenset(), keynum))
        modified = self.maps.get((modifiers, keynum))
        return raw, modified


XINPUT_RE = re.compile(r'^key\s+(press|release)\s+(\d+)$')


class KeyPress:

    def __init__(self, keynum, modifiers, keymap):
        self.keynum = keynum
        self.modifiers = frozenset(modifiers)
        self.keymap = keymap

    def __str__(self):
        raw, modified = self.keymap.get_symbol(self.keynum, self.modifiers)
        tokens = sorted(self.modifiers) + [raw]
        if modified and modified != raw:
            tokens.append(f'({modified})')
        return ' '.join(str(t) for t in tokens)

    def __hash__(self):
        return hash((self.keynum, self.modifiers))

    def __eq__(self, other):
        return isinstance(other, type(self)) and \
           other.keynum == self.keynum and \
           other.modifiers == self.modifiers


def usage_report(stats, samples):
    started = False
    for section, sequences in stats.items():
        total = sum(sequences.values())
        ordered_seqences = sorted(
            sequences.items(), key=lambda s: s[1], reverse=True)
        if not started:
            started = True
        else:
            print()
        print(f'Most frequent {section}')
        print(f'=============={"=" * len(section)}')
        print()
        for seq, num in ordered_seqences[:samples]:
            n = f'{num}/{total}'
            print(f'{n:>14}  {num / total:-5.1%}  {seq}')


def main():
    parser = argparse.ArgumentParser(
        description='''
        Analyze keyboard usage statistics.
        ''')
    parser.add_argument(
        '-f', '--file',
        help='''
        File where to read/write keypress statistics. If set, the previous
        statistics will be read from it and they will be written periodically
        to it for future reuse. If unset, statistics will be dumped when the
        script is interrupted.
        ''')
    parser.add_argument(
        '-m', '--keymap-file',
        default='azerty-mod.keymap',
        help='''
        The keymap to associate symbols to keycodes.
        ''')
    parser.add_argument(
        '-r', '--report',
        action='store_true',
        help='''
        Only read previous statistics from FILE and dump a human readable
        report.
        ''')
    parser.add_argument(
        '-s', '--samples',
        metavar='N',
        type=int,
        default=20,
        help='''
        Display N samples in the statistics report.
        ''')
    parser.add_argument(
        '-k', '--keyboard-name',
        help='''
        The keyboard name to lookup its device ID from xinput --list.
        ''')

    args = parser.parse_args()

    if args.report and args.file is None:
        parser.error('--report requires --file')

    stats = {}
    if args.file is not None:
        try:
            with open(args.file, 'r') as f:
                stats = json.load(f)
        except Exception as e:
            try:
                with open(args.file, 'w') as f:
                    f.write('{}')
                os.chmod(args.file, 0o600)
            except Exception as ee:
                parser.error(f'--file: {e!r}')

    if args.report:
        return usage_report(stats, args.samples)

    if args.keyboard_name is None:
        parser.error('--keyboard-name is required')

    proc = subprocess.Popen(
        ['xinput', 'test', args.keyboard_name],
        stdout=subprocess.PIPE, stdin=subprocess.DEVNULL)

    try:
        keymap = KeyMap(args.keymap_file)
    except Exception as e:
        parser.error(f'--keymap-file: {e!r}')

    mods = set()
    prev_t = time.time()
    keys = collections.deque((), 3)

    while True:
        try:
            if proc.poll() is not None:
                break
            line = proc.stdout.readline().decode()
            match = XINPUT_RE.match(line.strip())
            if not match:
                continue

            action = match.group(1)
            keynum = int(match.group(2))

            if keynum in MODIFIERS:
                mod = MODIFIERS[keynum]
                if action == 'press':
                    mods.add(mod)
                else:
                    mods.discard(mod)

            elif action == 'press':
                t = time.time()
                if t > prev_t + 1:
                    if args.file is not None:
                        with open(args.file, 'w') as f:
                            json.dump(stats, f)
                    keys.clear()
                prev_t = t
                keys.append(KeyPress(keynum, mods, keymap))

                for n in range(1, 4):
                    if len(keys) < n:
                        continue
                    section = stats.setdefault(f'{n}-key sequences', {})
                    seq = '  ->  '.join(
                        str(keys[i]) for i in range(len(keys) - n, len(keys)))
                    if seq in section:
                        section[seq] += 1
                    else:
                        section[seq] = 1

        except (BrokenPipeError, KeyboardInterrupt):
            proc.terminate()
            proc.wait()
            break

    if args.file is not None:
        with open(args.file, 'w') as f:
            json.dump(stats, f)
    else:
        usage_report(stats, args.samples)


if __name__ == '__main__':
    main()
