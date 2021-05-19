#!/bin/sh

status=x

refresh_status() {
	if ssh -q -O check dio-ext >/dev/null 2>&1; then
		s=1
	else
		s=0
	fi
	if [ "$s" = "$status" ]; then
		# no change
		return
	fi
	status=$s
	if [ "$status" = 1 ]; then
		echo ' vpn'
		msg="Connected"
	else
		echo '%{F#888} vpn%{F-}'
		msg="Disconnected"
	fi
	notify-send "SSH VPN" "$msg"
}

refresh_status

while inotifywait -qq -e create -e delete ~/.ssh; do
	refresh_status
done
