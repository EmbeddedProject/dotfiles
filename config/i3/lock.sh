#!/bin/bash

resolution=$(xdpyinfo | awk '/dimensions/{print $2}')
x=${resolution%x*}
y=${resolution#*x}
image=~/.i3lock-$resolution.png

if ! [ -f $image ]; then
	convert ~/.wallpaper.png \
		-background '#0e1624' -gravity center -extent "$resolution" \
		-font FontAwesome -pointsize 70 -fill grey -stroke grey \
		-gravity center -annotate "+0+$(((y / 2) - 100))" "" \
		$image
fi

exec i3lock -fnei $image
