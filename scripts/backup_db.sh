#!/bin/bash

# Backup Database
#
# Backup the local database in to a compressed .sql.gz archive
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.2.0
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
    if [[ ! -f "${DIR}/${INCLUDE_FILE}" ]] ; then
        echo "File ${DIR}/${INCLUDE_FILE} is missing, aborting."
        exit 1
    fi
    source "${DIR}/${INCLUDE_FILE}"
done

# Functions
function backup_mysql() {
    $LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS $MYSQLDUMP_SCHEMA_ARGS > "$BACKUP_DB_PATH"
    $LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS $LOCAL_IGNORED_DB_TABLES_STRING $MYSQLDUMP_DATA_ARGS >> "$BACKUP_DB_PATH"
}
function backup_pgsql() {
    echo ${LOCAL_DB_HOST}:${LOCAL_DB_PORT}:${LOCAL_DB_NAME}:${LOCAL_DB_USER}:${LOCAL_DB_PASSWORD} > "${TMP_DB_DUMP_CREDS_PATH}"
    chmod 600 "${TMP_DB_DUMP_CREDS_PATH}"
    PGPASSFILE="${TMP_DB_DUMP_CREDS_PATH}" $LOCAL_PG_DUMP_CMD $LOCAL_DB_CREDS $LOCAL_IGNORED_DB_TABLES_STRING $PG_DUMP_ARGS --schema="${LOCAL_DB_SCHEMA}" --file="${BACKUP_DB_PATH}"
    rm "${TMP_DB_DUMP_CREDS_PATH}"
}

# Source the correct file for the database driver
case "$GLOBAL_DB_DRIVER" in
    ( 'mysql' ) source "${DIR}/common/common_mysql.sh" ;;
    ( 'pgsql' ) source "${DIR}/common/common_pgsql.sh" ;;
    ( * )
        echo "Environment variable GLOBAL_DB_DRIVER was neither 'mysql' nor 'pgsql'. Aborting."
        exit 1 ;;
esac

# Set the backup db file name, parent directory path, and full path
BACKUP_DB_NAME="${LOCAL_DB_NAME}-db-backup-$(date '+%Y%m%d-%H%M%S').sql"
BACKUP_DB_DIR_PATH="${LOCAL_BACKUPS_PATH}${LOCAL_DB_NAME}/${DB_BACKUP_SUBDIR}/"
BACKUP_DB_PATH="${BACKUP_DB_DIR_PATH}${BACKUP_DB_NAME}"

# Make sure the directory exists
echo "Ensuring backup directory exists at '${BACKUP_DB_DIR_PATH}'"
mkdir -p "${BACKUP_DB_DIR_PATH}"

# Backup the local db
case "$GLOBAL_DB_DRIVER" in
    ( 'mysql' ) backup_mysql ;;
    ( 'pgsql' ) backup_pgsql ;;
esac
gzip -f "$BACKUP_DB_PATH"
echo "*** Backed up local database to ${BACKUP_DB_PATH}.gz"

# Remove backups older than LOCAL_BACKUPS_MAX_AGE
TMP_LOG_PATH="/tmp/${LOCAL_DB_NAME}-db-backups.log"
find "${BACKUP_DB_DIR_PATH}" -name "*.sql.gz" -mtime +${GLOBAL_DB_BACKUPS_MAX_AGE} -exec rm -fv "{}" \; &> $TMP_LOG_PATH

# Report on what we did
FILE_COUNT=$(cat $TMP_LOG_PATH | wc -l)
DETAILS_MSG="; details logged to ${TMP_LOG_PATH}"
case $FILE_COUNT in
    ( 0 ) DETAILS_MSG="" ;;
    ( 1 ) PLURAL_CHAR="" ;;
esac
echo "*** ${FILE_COUNT} old database backup${PLURAL_CHAR} removed${DETAILS_MSG}"

# Normal exit
exit 0
