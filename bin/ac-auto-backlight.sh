#!/bin/sh

ac_online_sysfs="/sys/class/power_supply/AC/online"
ac_online=x

update_backlight() {
	online=$(cat $ac_online_sysfs)
	if [ "$online" = "$ac_online" ]; then
		# no change
		return
	fi
	echo "AC power online=$ac_online"
	ac_online=$online
	if [ "$ac_online" = "1" ]; then
		~/bin/backlight.sh set 100%
	else
		~/bin/backlight.sh set 40%
	fi
}

update_backlight

while inotifywait -qq -e access "$ac_online_sysfs"; do
	update_backlight
done
