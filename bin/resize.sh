#!/bin/sh

printf '\0337\033[r\033[999;999H\033[6n'
while read -r -t 1 -n 1 p 0< /dev/tty
do
	printf '%s' "$p"
done |
sed -rn 's/^[^0-9]+([0-9]+);([0-9]+)R$/stty rows \1 columns \2/p' |
{
	read -r cmd
	$cmd 0< /dev/tty
	echo
}


# printf '\0337\033[r\033[999;999H\033[6n'; while read -r -t 1 -n 1 p 0< /dev/tty; do printf '%s' "$p"; done | sed -rn 's/^[^0-9]*([0-9]+);([0-9]+)R$/stty rows \1 columns \2/p' | { read -r cmd; $cmd 0< /dev/tty; echo; }
