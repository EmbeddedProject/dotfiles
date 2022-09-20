#!/usr/bin/env python3
# Copyright (c) 2022 Robin Jarry
# SPDX-License-Identifier: MIT

"""
Convert a bit list into a hex mask or the other way around.
"""

import argparse
import re
import typing


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "args",
        type=mask_or_list,
        metavar="MASK_OR_LIST",
        nargs="+",
        help="""
        A set of bits specified as a hexadecimal mask value (e.g. 0xeec2) or as
        a comma-separated list of bit IDs. Consecutive ids can be compressed as
        ranges (e.g. 5,6,7,8,9,10 --> 5-10).
        """
    )
    g = parser.add_argument_group("mode").add_mutually_exclusive_group()
    g.add_argument(
        "-m",
        "--mask",
        action="store_const",
        dest="mode",
        const=cpu_mask,
        help="""
        Print the combined args as a hexadecimal mask value (default).
        """
    )
    g.add_argument(
        "-b",
        "--bit",
        action="store_const",
        dest="mode",
        const=bit_mask,
        help="""
        Print the combined args as a bit mask value.
        """
    )
    g.add_argument(
        "-l",
        "--list",
        action="store_const",
        dest="mode",
        const=cpu_list,
        help="""
        Print the combined args as a list of bit IDs. Consecutive IDs are
        compressed as ranges.
        """
    )
    parser.set_defaults(mode=cpu_mask)
    args = parser.parse_args()
    cpu_ids = set()
    for a in args.args:
        cpu_ids.update(a)
    print(args.mode(cpu_ids))


HEX_RE = re.compile(r"0x[0-9a-fA-F]+")
RANGE_RE = re.compile(r"\d+-\d+")
INT_RE = re.compile(r"\d+")


def mask_or_list(arg: str) -> typing.Set[int]:
    cpu_ids = set()
    for item in arg.strip().split(","):
        if not item:
            continue
        if HEX_RE.match(item):
            item = int(item, 16)
            cpu = 0
            while item != 0:
                if item & 1:
                    cpu_ids.add(cpu)
                cpu += 1
                item >>= 1
        elif RANGE_RE.match(item):
            start, end = item.split("-")
            cpu_ids.update(range(int(start, 10), int(end, 10) + 1))
        elif INT_RE.match(item):
            cpu_ids.add(int(item, 10))
        else:
            raise argparse.ArgumentTypeError(f"invalid argument: {item}")
    return cpu_ids


def cpu_mask(cpu_ids: typing.Set[int]) -> str:
    mask = 0
    for cpu in cpu_ids:
        mask |= 1 << cpu
    return hex(mask)


def bit_mask(cpu_ids: typing.Set[int]) -> str:
    mask = 0
    for cpu in cpu_ids:
        mask |= 1 << cpu
    return f"0b{mask:_b}"


def cpu_list(cpu_ids: typing.Set[int]) -> str:
    groups = []
    cpu_ids = sorted(cpu_ids)
    i = 0
    while i < len(cpu_ids):
        low = cpu_ids[i]
        while i < len(cpu_ids) - 1 and cpu_ids[i] + 1 == cpu_ids[i + 1]:
            i += 1
        high = cpu_ids[i]
        if low == high:
            groups.append(str(low))
        elif low + 1 == high:
            groups.append(f"{low},{high}")
        else:
            groups.append(f"{low}-{high}")
        i += 1
    return ",".join(groups)


if __name__ == "__main__":
    main()
