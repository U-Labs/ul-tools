#!/bin/bash
user=root
target_dir=/backups
pw=$(env |grep MYSQL_ROOT | awk -F'=' '{print $2}')
dbs=$(mysql -u $user -p"$pw" -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)")

#if ! command -v 7z &> /dev/null; then
#	echo "7zip not found, installing..."
#	apt-get update
#	apt-get install -y p7zip-full
#fi

date=$(date +'%d.%m.%Y_%H-%M-%S')
full_target_dir="$target_dir/$date"
mkdir $full_target_dir
chmod 660 $full_target_dir
echo "Target: $full_target_dir"

for db in $dbs; do
        echo "Export Db $db"
  # Speichertests 13.12.2018
  # gzip 203MB
  # 76z  142MB (level7)
  # Standard: Alle DBs werden gesperr
  mysqldump --lock-tables=false --user=$user -p"$pw" --databases $db > "$full_target_dir/$db.sql"
  #mysqldump --lock-tables=false --user=$user -p"$pw" --databases $db | gzip > "$full_target_dir/$db.gz"
  #mysqldump --lock-tables=false --user=$user -p$pw --databases $db | 7z a -si -t7z -m0=LZMA -mmt=on -mx=7 -md=32m -mfb=24 "$full_target_dir/$db.7z"
done