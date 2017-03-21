#!/bin/bash

# Restore Database
#
# Restore the local database to the file path passed in via ARGV
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.1.1
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
    CAT_CMD="zcat"
fi
if [ "${SRC_DB_PATH: -4}" == ".sql" ] ; then
    CAT_CMD="cat"
fi
if [ "${CAT_CMD}" == "" ] ; then
    echo "Unknown file type"
    exit 1
fi

# Temporary db dump path (remote & local)
BACKUP_DB_PATH="/tmp/${LOCAL_DB_NAME}-db-backup-$(date '+%Y%m%d').sql"

# Backup the local db
$LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS $MYSQLDUMP_SCHEMA_ARGS > "$BACKUP_DB_PATH"
$LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS $MYSQLDUMP_DATA_ARGS >> "$BACKUP_DB_PATH"
gzip -f "$BACKUP_DB_PATH"
echo "*** Backed up local database to ${BACKUP_DB_PATH}.gz"

# Restore the local db from the passed in db dump
$CAT_CMD "${SRC_DB_PATH}" | $LOCAL_MYSQL_CMD $LOCAL_DB_CREDS
echo "*** Restored local database from ${SRC_DB_PATH}"

# Normal exit
exit 0
