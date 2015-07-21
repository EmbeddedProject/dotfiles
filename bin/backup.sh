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
**.img
**.qcow2
'
for e in $excludes; do
	opts="$opts --exclude='$e'"
done

cd ~
folders='
bin
devel
Documents
'

echo "rsync $opts $folders $backup_user@$backup_machine:~/BACKUP-$(hostname)" >"$logfile"
rsync $opts $folders $backup_user@$backup_machine:~/BACKUP-$(hostname) >>"$logfile" 2>&1

mail -s "Backup to $backup_machine: $now" "$email" <"$logfile"
