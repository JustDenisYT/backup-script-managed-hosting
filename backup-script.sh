#/bin/bash


# Comment for debugging mode:
2> /dev/null

# Little script to save all webspace, databases and crontab on 1&1 managed servers.
#
# 10.03.2015

# If you do not want to backup ALL files and folders, you can fill in some excludes here:
# Excample: 
# 
# exclude="--exclude=logs --exclude=backup --exclude=foo --exclude=bar"
#
excludes="
--exclude=logs 
--exclude=backup 
--exclude= 
--exclude="

# 1st step - create the backupfolders:
if [ ! -d "~/backup" ]; then
	mkdir backup
fi

if [ ! -d "~/backup/mysql-dumps" ]; then
	mkdir backup/mysl-dumps
fi

# Create .htaccess for deny:
touch backup/.htaccess && echo "deny from all" >> backup/.htaccess

# Fill in the needed values to dump your database(s):
db_name=""
db_user=""
db_pass=""

mysqldump --no-tablespace --host=localhost --user=$db_user --password=$db_pass -S /tmp/mysql5.sock $db_name > backup/mysql-dumps/$db_name.dump

# Copy the following part if you have more databases:
#---------------------------------------------------#
# 2nd Database (uncomment if needed):
#db2_name=""
#db2_user=""
#db2_pass=""

#mysqldump --no-tablespace --host=localhost --user=$db2_user --password=$db2_pass -S /tmp/mysql5.sock $db2_name > backup/mysql-dumps/$db2_name.dump
#---------------------------------------------------#

# Save the crontab to a txt-file
crontab -l >> backup/crontab.txt

# Create the tar ball of the whole space with the wanted excludes
tar -cf full_backup_$(date +"%F").tar * --exclude=$excludes

# Copy the backups to external path using scp:
# Comment the line if you are manually downloading your backups
scp -r backup/full_backup_* user@host:/path/to/backups

# Remove all backupfiles older than 7 days:
find ~/backup/ -type f -mtime +7 -exec rm -rf {} \;
exit 0
