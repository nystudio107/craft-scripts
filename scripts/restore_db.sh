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
    if [ -f "${DIR}/${INCLUDE_FILE}" ]
    then
        source "${DIR}/${INCLUDE_FILE}"
    else
        echo "File ${DIR}/${INCLUDE_FILE} is missing, aborting."
        exit 1
    fi
done
if [ "${GLOBAL_DB_DRIVER}" == "mysql" ] ; then
    source "${DIR}/common/common_mysql.sh"
fi
if [ "${GLOBAL_DB_DRIVER}" == "pgsql" ] ; then
    source "${DIR}/common/common_pgsql.sh"
fi

# Get the path to the database passed in
SRC_DB_PATH=$1
if [ "${SRC_DB_PATH}" == "" ] ; then
    echo "No input database dump specified"
    exit 1
fi
if [[ ! -f "${SRC_DB_PATH}" ]] ; then
    echo "File not found"
    exit 1
fi

# Figure out what type of file we're being passed in
CAT_CMD=""
if [ "${SRC_DB_PATH: -3}" == ".gz" ] ; then
    CAT_CMD="${DB_ZCAT_CMD}"
fi
if [ "${SRC_DB_PATH: -4}" == ".sql" ] ; then
    CAT_CMD="${DB_CAT_CMD}"
fi
if [ "${CAT_CMD}" == "" ] ; then
    echo "Unknown file type"
    exit 1
fi

# Temporary db dump path (remote & local)
BACKUP_DB_PATH="/tmp/${LOCAL_DB_NAME}-db-backup-$(date '+%Y%m%d').sql"

# Backup the local db
if [ "${GLOBAL_DB_DRIVER}" == "mysql" ] ; then
    $LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS $MYSQLDUMP_SCHEMA_ARGS > "$BACKUP_DB_PATH"
    $LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS $LOCAL_IGNORED_DB_TABLES_STRING $MYSQLDUMP_DATA_ARGS >> "$BACKUP_DB_PATH"
fi
if [ "${GLOBAL_DB_DRIVER}" == "pgsql" ] ; then
    echo ${LOCAL_DB_HOST}:${LOCAL_DB_PORT}:${LOCAL_DB_NAME}:${LOCAL_DB_USER}:${LOCAL_DB_PASSWORD} > "${TMP_DB_DUMP_CREDS_PATH}"
    chmod 600 "${TMP_DB_DUMP_CREDS_PATH}"
    PGPASSFILE="${TMP_DB_DUMP_CREDS_PATH}" $LOCAL_PG_DUMP_CMD $LOCAL_DB_CREDS $LOCAL_IGNORED_DB_TABLES_STRING $PG_DUMP_ARGS --schema="${LOCAL_DB_SCHEMA}" --file="${BACKUP_DB_PATH}"
    rm "${TMP_DB_DUMP_CREDS_PATH}"
fi
gzip -f "$BACKUP_DB_PATH"
echo "*** Backed up local database to ${BACKUP_DB_PATH}.gz"

# Restore the local db from the passed in db dump
if [ "${GLOBAL_DB_DRIVER}" == "mysql" ] ; then
    $CAT_CMD "${SRC_DB_PATH}" | $LOCAL_MYSQL_CMD $LOCAL_DB_CREDS
fi
if [ "${GLOBAL_DB_DRIVER}" == "pgsql" ] ; then
    echo ${LOCAL_DB_HOST}:${LOCAL_DB_PORT}:${LOCAL_DB_NAME}:${LOCAL_DB_USER}:${LOCAL_DB_PASSWORD} > "${TMP_DB_DUMP_CREDS_PATH}"
    chmod 600 "${TMP_DB_DUMP_CREDS_PATH}"
    $CAT_CMD "${SRC_DB_PATH}" | PGPASSFILE="${TMP_DB_DUMP_CREDS_PATH}" $LOCAL_PSQL_CMD $LOCAL_DB_CREDS --no-password >/dev/null
    rm "${TMP_DB_DUMP_CREDS_PATH}"
fi
echo "*** Restored local database from ${SRC_DB_PATH}"

# Normal exit
exit 0
