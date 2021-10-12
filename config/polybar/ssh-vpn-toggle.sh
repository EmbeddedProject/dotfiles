#!/bin/sh

exec 9>$XDG_RUNTIME_DIR/ssh-vpn.lock

flock -n 9 || exit

notify() {
	notify-send -u normal -t 5000 -a "SSH VPN" \
		-h string:synchronous:ssh-vpn "SSH VPN" "$@"
}

if ssh -q -O check dio-ext >/dev/null 2>&1; then
	notify "Disconnecting..."
	ssh -O exit dio-ext ||
		notify "error: failed to disconnect"
else
	notify "Connecting..."
	ssh -f dio-socks 'tail -f /dev/null' ||
		notify "error: failed to connect"
fi

wait
