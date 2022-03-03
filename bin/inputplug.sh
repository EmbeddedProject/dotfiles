#!/bin/bash

set -e

exec >>~/.xsession-errors 2>&1
exec 9>$XDG_RUNTIME_DIR/inputplug.lock

flock -n 9 || exit 1

event="$1"
device_id="$2"
device_type="$3"
device_name="$4"

case "$event-$device_type" in
XIDeviceEnabled-XISlaveKeyboard)
	case "$device_name" in
	*YubiKey*)
		# force querty for HOTP digits
		setxkbmap -device $device_id us
		;;
	*)
		setxkbmap -device $device_id fr
		# key repeat rate, 200ms delay, 40 repeats/sec.
		xset r rate 200 40
		if [ -r ~/.Xmodmap ]; then
			xmodmap ~/.Xmodmap
		fi
		# enable numlock when starting X
		numlockx on
		;;
	esac
	;;
esac
