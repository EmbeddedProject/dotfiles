#!/bin/sh

exec 9>$XDG_RUNTIME_DIR/ssh-vpn.lock

flock -n 9 || exit

if ssh -q -O check dio-ext >/dev/null 2>&1; then
	notify-send -t 3000 "SSH VPN" "Disconnecting..."
	ssh -O exit dio-ext ||
		notify-send -u critical "SSH VPN" "error: failed to disconnect"
else
	notify-send -t 3000 "SSH VPN" "Connecting..."
	ssh -f dio-socks 'tail -f /dev/null' ||
		notify-send -u critical "SSH VPN" "error: failed to connect"
fi

wait
