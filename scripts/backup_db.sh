#!/bin/bash

# Backup Database
#
# Backup the local database in to a compressed .sql.gz archive
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.0.4
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

# Make sure the directory exists
if [[ ! -d "${LOCAL_BACKUPS_PATH}" ]] ; then
    echo "Creating backup directory ${LOCAL_BACKUPS_PATH}"
    mkdir "${LOCAL_BACKUPS_PATH}"
fi

# Set the backup db file name, parent directory path, and full path
BACKUP_DB_NAME="${LOCAL_DB_NAME}-db-backup-$(date '+%Y%m%d-%H%M%S').sql"
BACKUP_DB_DIR_PATH="${LOCAL_BACKUPS_PATH}${LOCAL_DB_NAME}/"
BACKUP_DB_PATH="${BACKUP_DB_DIR_PATH}${BACKUP_DB_NAME}"

# Make sure the directory exists
if [[ ! -d "${BACKUP_DB_DIR_PATH}" ]] ; then
    echo "Creating backup directory ${BACKUP_DB_DIR_PATH}"
    mkdir "${BACKUP_DB_DIR_PATH}"
fi

# Backup the local db
$LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS --single-transaction --no-data > "$BACKUP_DB_PATH"
$LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS --no-create-info $IGNORED_TABLES_STRING >> "$BACKUP_DB_PATH"
gzip -f $BACKUP_DB_PATH
echo "*** Backed up local database to ${BACKUP_DB_PATH}.gz"

# Remove backups older than LOCAL_BACKUPS_MAX_AGE
TMP_LOG_PATH="/tmp/${REMOTE_DB_NAME}-db-backups.log"
find "${BACKUP_DB_DIR_PATH}" -name "*.sql.gz" -ctime ${LOCAL_BACKUPS_MAX_AGE} -exec rm -fv "{}" \; &> $TMP_LOG_PATH
FILE_COUNT=`cat $TMP_LOG_PATH | wc -l`
PLURAL_CHAR="s"
if [ $FILE_COUNT == 1 ] ; then
    PLURAL_CHAR=""
fi
DETAILS_MSG="; details logged to ${TMP_LOG_PATH}"
if [ $FILE_COUNT == 0 ] ; then
    DETAILS_MSG=""
fi
echo "*** ${FILE_COUNT} old database backup${PLURAL_CHAR} removed${DETAILS_MSG}"
