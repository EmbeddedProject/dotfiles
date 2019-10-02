#!/usr/bin/env python3
"""
Search for people in 6WIND LDAP directory.
"""

import argparse
import codecs
import locale
import sys

import ldap


LDAP_URI = 'ldap://ldap.6wind.com'
LDAP_BASE_DN = 'ou=people,dc=6wind,dc=com'
LDAP_BIND_DN = ''
LDAP_BIND_PW = ''


def main():
    parser = argparse.ArgumentParser(description=__doc__)

    parser.add_argument('patterns',
                        metavar='PATTERN',
                        help='Shell-like pattern to filter names/emails.',
                        nargs='+')

    args = parser.parse_args()

    ldap_filter = '(|'
    for p in args.patterns:
        if p.lower() == 'jmg':
            p = 'guerin'
        ldap_filter += '(cn=*%s*)' % p
        ldap_filter += '(mail=*%s*)' % p
    ldap_filter += ')'

    l = ldap.initialize(LDAP_URI)
    try:
        l.protocol_version = ldap.VERSION3
        l.set_option(ldap.OPT_X_TLS_REQUIRE_CERT, ldap.OPT_X_TLS_DEMAND)
        l.set_option(ldap.OPT_X_TLS_CACERTFILE, '/etc/ssl/certs/ca-certificates.crt')
        l.set_option(ldap.OPT_X_TLS_NEWCTX, 0)

        l.start_tls_s()
        l.simple_bind_s(LDAP_BIND_DN, LDAP_BIND_PW)

        res = l.search_s(
            LDAP_BASE_DN, ldap.SCOPE_SUBTREE, ldap_filter, ['cn', 'mail'])

        matches = []
        for _, attrs in res:
            if 'cn' in attrs and 'mail' in attrs:
                email = attrs['mail'][0].decode().lower()
                name = attrs['cn'][0].decode()
                matches.append((email, name))
        print(len(matches), 'entries found')
        for email, name in sorted(matches):
            print('%s\t%s' % (email, name))
    finally:
        l.unbind()

if __name__ == '__main__':
    main()
