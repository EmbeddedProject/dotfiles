#!/bin/sh

backup_user=jarry
backup_machine=paques
logfile=~/backup-paques.log
email=robin.jarry@6wind.com
now="$(date '+%a %d %b %Y %R')"

opts="
--archive
--verbose
--compress
--human-readable
--delete-excluded
--delete-after
"
excludes='
**.o
**.a
**.pyc
**.pyo
**.6os
**bzImage
**vmlinux
**vmlinuz
**/build/
**/.venv/
**.img
**.qcow2
'
for e in $excludes; do
	opts="$opts --exclude='$e'"
done

cd ~
folders='
.config
.ssh
bin
dev
Documents
'

exec >$logfile 2>&1
set -x

eval rsync $opts $folders "$backup_user@$backup_machine:BACKUP-$(hostname)" \
	&& failed= || failed=' FAILED'

{
	head $logfile
	echo "[... truncated ...]"
	tail $logfile
} | mail -s "[BACKUP]$failed: $now" "$email"
