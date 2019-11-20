#!/bin/sh

export LESSOPEN='|/usr/share/source-highlight/src-hilite-lesspipe.sh "%s"'

exec xterm -e "less -RS $1"
