#!/bin/bash

# Pull Database
#
# Pull remote database down from a remote and restore it to to local
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.1.0
# @license   MIT

# Get the directory of the currently executing script
DIR="$(dirname "${BASH_SOURCE[0]}")"

# Include files
INCLUDE_FILES=(
            "common/defaults.sh"
            ".env.sh"
            "common/common_env.sh"
            "common/common_db.sh"
            )
for INCLUDE_FILE in "${INCLUDE_FILES[@]}"
do
    if [ -f "${DIR}/${INCLUDE_FILE}" ]
    then
        source "${DIR}/${INCLUDE_FILE}"
    else
        echo 'File "${DIR}/${INCLUDE_FILE}" is missing, aborting.'
        exit 1
    fi
done

# Temporary db dump path (remote & local)
TMP_DB_PATH="/tmp/${REMOTE_DB_NAME}-db-dump-$(date '+%Y%m%d').sql"
BACKUP_DB_PATH="/tmp/${LOCAL_DB_NAME}-db-backup-$(date '+%Y%m%d').sql"

# Get the remote db dump
ssh $REMOTE_SSH_LOGIN -p $REMOTE_SSH_PORT "$REMOTE_MYSQLDUMP_CMD $REMOTE_DB_CREDS $MYSQLDUMP_SCHEMA_ARGS > '$TMP_DB_PATH' ; $REMOTE_MYSQLDUMP_CMD $REMOTE_DB_CREDS $MYSQLDUMP_DATA_ARGS >> '$TMP_DB_PATH' ; gzip -f '$TMP_DB_PATH'"
scp -P $REMOTE_SSH_PORT -- $REMOTE_SSH_LOGIN:"${TMP_DB_PATH}.gz" "${TMP_DB_PATH}.gz"

# Backup the local db
$LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS $MYSQLDUMP_SCHEMA_ARGS > "$BACKUP_DB_PATH"
$LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS $MYSQLDUMP_DATA_ARGS >> "$BACKUP_DB_PATH"
gzip -f "$BACKUP_DB_PATH"
echo "*** Backed up local database to ${BACKUP_DB_PATH}.gz"

# Restore the local db from the remote db dump
zcat "${TMP_DB_PATH}.gz" | $LOCAL_MYSQL_CMD $LOCAL_DB_CREDS
echo "*** Restored local database from ${TMP_DB_PATH}.gz"

# Normal exit
exit 0
