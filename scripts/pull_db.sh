#!/bin/bash

# Pull Database
#
# Pull remote database down from a remote and restore it to to local
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.0.2
# @license   MIT

# Make sure the `.env.sh` exists
if [[ ! -f ".env.sh" ]] ; then
    echo 'File ".env.sh" is missing, aborting.'
    exit
fi
source ".env.sh"

# Make sure the `common_db.sh` exists
if [[ ! -f "common/common_db.sh" ]] ; then
    echo 'File "common/common_db.sh" is missing, aborting.'
    exit
fi
source "common/common_db.sh"

# Make sure the `common_env.sh` exists
if [[ ! -f "common/common_env.sh" ]] ; then
    echo 'File "common/common_env.sh" is missing, aborting.'
    exit
fi
source "common/common_env.sh"

# Temporary db dump path (remote & local)
TMP_DB_PATH="/tmp/${REMOTE_DB_NAME}-db-dump-$(date '+%Y%m%d').sql"
BACKUP_DB_PATH="/tmp/${LOCAL_DB_NAME}-db-backup-$(date '+%Y%m%d').sql"

# Get the remote db dump
ssh $REMOTE_SSH_LOGIN -p $REMOTE_SSH_PORT "$REMOTE_MYSQLDUMP_CMD $REMOTE_DB_CREDS --single-transaction --no-data > '$TMP_DB_PATH' ; $REMOTE_MYSQLDUMP_CMD $REMOTE_DB_CREDS --no-create-info $IGNORED_TABLES_STRING >> '$TMP_DB_PATH'"
scp -P $REMOTE_SSH_PORT -- $REMOTE_SSH_LOGIN:"$TMP_DB_PATH" "$TMP_DB_PATH"

# Backup the local db
$LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS --single-transaction --no-data > "$BACKUP_DB_PATH"
$LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS --no-create-info $IGNORED_TABLES_STRING >> "$BACKUP_DB_PATH"
echo "*** Backed up local database to $BACKUP_DB_PATH"

# Restore the local db from the remote db dump
$LOCAL_MYSQL_CMD $LOCAL_DB_CREDS < "$TMP_DB_PATH"
echo "*** Restored local database from $TMP_DB_PATH"
