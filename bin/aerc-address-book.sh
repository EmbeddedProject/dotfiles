#!/bin/sh

if ssh -q -O check dio-ext >/dev/null 2>&1; then
	exec ssh dio-ext "exec ~/bin/mutt-ldap-search.py" "$*"
else
	exec ~/bin/mutt-ldap-search.py "$*"
fi
