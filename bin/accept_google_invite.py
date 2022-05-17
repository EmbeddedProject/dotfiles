#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
# Copyright (c) 2022 Robin Jarry

"""
Parse a Google invite email and accept the invitation by opening the proper
link in your web browser.
"""

import argparse
import email
import sys
import webbrowser
from html.parser import HTMLParser


class GoogleEventUrlParser(HTMLParser):
    def __init__(self, attendance="Yes"):
        super().__init__()
        self._attendance = attendance
        self._meta_attrs = {
            "itemprop": "attendance",
            "content": f"http://schema.org/RsvpAttendance/{attendance}",
        }
        self._check_next_link = False

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == "meta" and attrs == self._meta_attrs:
            self._check_next_link = True
        elif self._check_next_link and tag == "a" and "href" in attrs:
            self._check_next_link = False
            webbrowser.open(attrs["href"])
            print(f"replied {self._attendance} to the invitation")
            sys.exit(0)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    g = parser.add_mutually_exclusive_group()
    g.add_argument(
        "-y",
        "--yes",
        dest="attendance",
        action="store_const",
        default="Yes",
        const="Yes",
        help="""
        Accept the invitation (the default).
        """,
    )
    g.add_argument(
        "-n",
        "--no",
        dest="attendance",
        action="store_const",
        const="No",
        help="""
        Decline the invitation.
        """,
    )
    g.add_argument(
        "-m",
        "--maybe",
        dest="attendance",
        action="store_const",
        const="Maybe",
        help="""
        Tentatively accept the invitation.
        """,
    )
    args = parser.parse_args()

    message = email.message_from_file(sys.stdin)

    for part in message.walk():
        if part.get_content_type() == "text/html":
            html = part.get_payload(decode=True).decode()
            GoogleEventUrlParser(args.attendance).feed(html)

    print(f"error: cannot find invitation link")
    sys.exit(1)


if __name__ == "__main__":
    main()
