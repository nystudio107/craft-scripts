#!/bin/bash

# Rotate Dirs backups
#
# Rotate local files backups
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

# Set the backup directory paths
BACKUP_FILES_DIR="${LOCAL_BACKUPS_PATH}${LOCAL_DB_NAME}/${FILES_BACKUP_SUBDIR}"
BACKUP_FILES_DIR_OLD=${BACKUP_FILES_DIR}.old

# Only rotate the backup if we have a new one
if [ -d "${BACKUP_FILES_DIR}" ]
then
    echo "Moving backup directory ${BACKUP_FILES_DIR} to ${BACKUP_FILES_DIR_OLD}"
    rm -rf "${BACKUP_FILES_DIR_OLD}"
    mv "${BACKUP_FILES_DIR}" "${BACKUP_FILES_DIR_OLD}"
fi

# Normal exit
exit 0

