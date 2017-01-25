#!/bin/bash

# Craft-Permissions
# @author    nystudio107
# @copyright Copyright (c) 2016 nystudio107
# @link      https://nystudio107.com/
# @package   craft-permissions
# @since     1.0.1
# @license   MIT

# Make sure the `.env.sh` exists
if [[ ! -f ".env.sh" ]] ; then
    echo 'File ".env.sh" is missing, aborting.'
    exit
fi

source ".env.sh"

# Temporary db dump path (remote & local)
TMP_DB_PATH="/tmp/"$REMOTE_DB_NAME"-db-dump-"$(date '+%Y%m%d')".sql"
BACKUP_DB_PATH="/tmp/"$LOCAL_DB_NAME"-db-backup-"$(date '+%Y%m%d')".sql"

ssh $REMOTE_SSH_LOGIN -p $REMOTE_SSH_PORT "mysqldump --user='$REMOTE_DB_USER' --password='$REMOTE_DB_PASSWORD' --host=$REMOTE_DB_HOST --port=$REMOTE_DB_PORT '$REMOTE_DB_NAME' > $TMP_DB_PATH"
scp -P $REMOTE_SSH_PORT -- $REMOTE_SSH_LOGIN:"$TMP_DB_PATH" "$TMP_DB_PATH"
$LOCAL_MYSQLDUMP_CMD --user="$LOCAL_DB_USER" --password="$LOCAL_DB_PASSWORD" "$LOCAL_DB_NAME" > "$BACKUP_DB_PATH"
echo "*** Backed up local database to $BACKUP_DB_PATH"
$LOCAL_MYSQL_CMD --user="$LOCAL_DB_USER" --password="$LOCAL_DB_PASSWORD" "$LOCAL_DB_NAME" < "$TMP_DB_PATH"
echo "*** Restored local database from $TMP_DB_PATH"
