# Little script to manage backups on managed hosting environments

Just cone this script and create a cronjob for daily automated usage:

    git clone https://github.com/MrAwesomeBro/backup-script-managed-hosting.git

Crontab:

    crontab -e
    00 00 * * * /path/to/backup-script.sh


