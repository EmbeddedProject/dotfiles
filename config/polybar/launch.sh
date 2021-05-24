#!/bin/sh

if polybar-msg cmd show >/dev/null 2>&1; then
	for pgid in $(ps -o pgid= $(pgrep -P $(pgrep polybar))); do
		kill -- -$pgid
	done
fi

if ! polybar-msg cmd restart; then
	polybar -p ~/.polybar.png foo &
fi
