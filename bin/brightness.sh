#!/bin/sh

set -e

action="${1?action}"

case "$action" in
+|inc|up)
	brightnessctl set +10%
	;;
-|dec|down)
	brightnessctl set 10%-
	;;
*)
	echo "error: invalid action: $action" >&2
	exit 1
	;;
esac



notify-send -u normal -t 1000 -a "Display Brightness" \
	-h string:synchronous:volume \
	-i ~/.local/share/icons/display-brightness.svg \
	"Display Brightness" $(brightnessctl i -m | cut -d, -f4)
