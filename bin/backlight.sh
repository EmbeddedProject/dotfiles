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
	brightnessctl "$@"
	;;
esac

current=$(brightnessctl i -m | cut -d, -f4)

notify-send -u normal -t 1000 -a "Display Brightness" \
	-h string:synchronous:backlight \
	-h string:x-canonical-private-synchronous:backlight \
	-h int:value:${current#%} \
	-i ~/.local/share/icons/display-brightness.svg \
	"Display Brightness" "$current"
