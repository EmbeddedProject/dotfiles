#!/bin/sh

if ssh -q -O check dio-ext >/dev/null 2>&1; then
	exec ssh dio-ext ~/bin/mutt-ldap-search.py "$@"
else
	exec python3 ~/bin/mutt-ldap-search.py "$@"
fi
