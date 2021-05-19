#!/bin/sh

exec 9>$XDG_RUNTIME_DIR/ssh-vpn.lock

flock -n 9 || exit

if ssh -q -O check dio-ext >/dev/null 2>&1; then
	notify-send -t 3000 "SSH VPN" "Disconnecting..."
	ssh -q -O exit dio-ext
else
	notify-send -t 3000 "SSH VPN" "Connecting..."
	ssh -nNf dio-socks
fi
