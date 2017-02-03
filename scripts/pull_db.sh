#!/bin/bash

# Pull Database
#
# Pull remote database down from a remote and restore it to to local
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-permissions
# @since     1.0.2
# @license   MIT

# Make sure the `.env.sh` exists
if [[ ! -f ".env.sh" ]] ; then
    echo 'File ".env.sh" is missing, aborting.'
    exit
fi

source ".env.sh"

# Tables to exclude from the dump
EXCLUDED_TABLES=(
            "assetindexdata"
            "assettransformindex"
            "sessions"
            "templatecaches"
            "templatecachecriteria"
            "templatecacheelements"
            )

IGNORED_TABLES_STRING=""
for TABLE in "${EXCLUDED_TABLES[@]}"
do
   IGNORED_TABLES_STRING+=" --ignore-table=${LOCAL_DB_NAME}.${GLOBAL_DB_TABLE_PREFIX}${TABLE}"
done

# Temporary db dump path (remote & local)
TMP_DB_PATH="/tmp/${REMOTE_DB_NAME}-db-dump-$(date '+%Y%m%d').sql"
BACKUP_DB_PATH="/tmp/${LOCAL_DB_NAME}-db-backup-$(date '+%Y%m%d').sql"

# Get the remote db dump
REMOTE_DB_CREDS="--user=${REMOTE_DB_USER} --password=${REMOTE_DB_PASSWORD} --host=${REMOTE_DB_HOST} --port=${REMOTE_DB_PORT} ${REMOTE_DB_NAME}"
ssh $REMOTE_SSH_LOGIN -p $REMOTE_SSH_PORT "mysqldump $REMOTE_DB_CREDS --single-transaction --no-data > '$TMP_DB_PATH' ; mysqldump $REMOTE_DB_CREDS --no-create-info $IGNORED_TABLES_STRING >> '$TMP_DB_PATH'"
scp -P $REMOTE_SSH_PORT -- $REMOTE_SSH_LOGIN:"$TMP_DB_PATH" "$TMP_DB_PATH"

# Backup the local db
LOCAL_DB_CREDS="--user=${LOCAL_DB_USER} --password=${LOCAL_DB_PASSWORD} ${LOCAL_DB_NAME}"
echo $LOCAL_DB_CREDS
$LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS --single-transaction --no-data > "$BACKUP_DB_PATH"
$LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS --no-create-info $IGNORED_TABLES_STRING >> "$BACKUP_DB_PATH"
echo "*** Backed up local database to $BACKUP_DB_PATH"

# Restore the local db from the remote db dump
$LOCAL_MYSQL_CMD $LOCAL_DB_CREDS < "$TMP_DB_PATH"
echo "*** Restored local database from $TMP_DB_PATH"
