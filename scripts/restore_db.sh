#!/bin/bash

# Restore Database
#
# Restore the local database to the file path passed in via ARGV
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

# Source the correct file for the database driver
case "$GLOBAL_DB_DRIVER" in
    ( 'mysql' ) source "${DIR}/common/common_mysql.sh" ;;
    ( 'pgsql' ) source "${DIR}/common/common_pgsql.sh" ;;
    ( * )
        echo "Environment variable GLOBAL_DB_DRIVER was neither 'mysql' nor 'pgsql'. Aborting."
        exit 1 ;;
esac

# Get the path to the database passed in
SRC_DB_PATH="$1"
if [[ -z "${SRC_DB_PATH}" ]] ; then
    echo "No input database dump specified via variable SRC_DB_PATH"
    exit 1
fi
if [[ ! -f "${SRC_DB_PATH}" ]] ; then
    echo "File not found for variable SRC_DB_PATH"
    exit 1
fi

# Figure out what type of file we're being passed in
case "$SRC_DB_PATH" in
    ( *.gz )  CAT_CMD="${DB_ZCAT_CMD}" ;;
    ( *.sql ) CAT_CMD="${DB_CAT_CMD}" ;;
    ( * )
        echo "Unknown file type for variable SRC_DB_PATH"
        exit 1 ;;
esac

# Temporary db dump path (remote & local)
BACKUP_DB_PATH="/tmp/${LOCAL_DB_NAME}-db-backup-$(date '+%Y%m%d').sql"

# Functions
function backup_local_mysql() {
    # Backup the local db
    $LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS $MYSQLDUMP_SCHEMA_ARGS > "$BACKUP_DB_PATH"
    $LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS $LOCAL_IGNORED_DB_TABLES_STRING $MYSQLDUMP_DATA_ARGS >> "$BACKUP_DB_PATH"
    gzip -f "$BACKUP_DB_PATH"
    echo "*** Backed up local database to ${BACKUP_DB_PATH}.gz"
}
function backup_local_pgsql() {
    # Backup the local db
    echo ${LOCAL_DB_HOST}:${LOCAL_DB_PORT}:${LOCAL_DB_NAME}:${LOCAL_DB_USER}:${LOCAL_DB_PASSWORD} > "${TMP_DB_DUMP_CREDS_PATH}"
    chmod 600 "${TMP_DB_DUMP_CREDS_PATH}"
    PGPASSFILE="${TMP_DB_DUMP_CREDS_PATH}" $LOCAL_PG_DUMP_CMD $LOCAL_DB_CREDS $LOCAL_IGNORED_DB_TABLES_STRING $PG_DUMP_ARGS --schema="${LOCAL_DB_SCHEMA}" --file="${BACKUP_DB_PATH}"
    rm "${TMP_DB_DUMP_CREDS_PATH}"
    gzip -f "$BACKUP_DB_PATH"
    echo "*** Backed up local database to ${BACKUP_DB_PATH}.gz"
}
function restore_local_from_dump_mysql() {
    # Restore the local db from the passed in db dump
    $CAT_CMD "${SRC_DB_PATH}" | $LOCAL_MYSQL_CMD $LOCAL_DB_CREDS
    echo "*** Restored local database from ${SRC_DB_PATH}"
}
function restore_local_from_dump_pgsql() {
    # Restore the local db from the passed in db dump
    echo ${LOCAL_DB_HOST}:${LOCAL_DB_PORT}:${LOCAL_DB_NAME}:${LOCAL_DB_USER}:${LOCAL_DB_PASSWORD} > "${TMP_DB_DUMP_CREDS_PATH}"
    chmod 600 "${TMP_DB_DUMP_CREDS_PATH}"
    $CAT_CMD "${SRC_DB_PATH}" | PGPASSFILE="${TMP_DB_DUMP_CREDS_PATH}" $LOCAL_PSQL_CMD $LOCAL_DB_CREDS --no-password >/dev/null
    rm "${TMP_DB_DUMP_CREDS_PATH}"
    echo "*** Restored local database from ${SRC_DB_PATH}"
}

case "$GLOBAL_DB_DRIVER" in
    ( 'mysql' )
        backup_local_mysql
        restore_local_from_dump_mysql
        ;;
    ( 'pgsql' )
        backup_local_pgsql
        restore_local_from_dump_pgsql
        ;;
esac

# Normal exit
exit 0
