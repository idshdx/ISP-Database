#Script used to backup databases
#Backups older than 10 days are removed
#!/bin/sh

export PGPASSWORD=$1

logfile="/var/lib/pgsql.log"
backup_dir="/var/backup"
dateinfo=`date '+%Y-%m-%d %H:%M:%S'`
timespan=`date '+%Y%m%d%H%M'`

touch $logfile

databases=`psql -U postgres -t -c "select datname from pg_database where datname not like 'template%';"$

#delete files older than 10 days
find ./$backup_dir/ -mtime +10 -type f -delete

echo "Starting backup of databases at $dateinfo" >> $logfile
for i in $databases; do
        /usr/bin/vacuumdb -z -h localhost -U postgres $i >/dev/null 2>&1
        /usr/bin/pg_dump -U postgres -F c -b $i -h 127.0.0.1 -f $backup_dir/$i-database-$timespan.backup
        echo "Backup and Vacuum complete on $dateinfo for database: $i " >> $logfile
done

echo "Done backup of databases " >> $logfile
echo "pgbackup.sh: Done making backups"

tail -15 /var/lib/pgsql.log | mailx andrei@cloud-ro.com
