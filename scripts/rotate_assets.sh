#!/bin/bash

# Rotate Assets
#
# Rotate local assets backups
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
BACKUP_ASSETS_DIR="${LOCAL_BACKUPS_PATH}${LOCAL_DB_NAME}/${ASSETS_BACKUP_SUBDIR}"
BACKUP_ASSETS_DIR_OLD=${BACKUP_ASSETS_DIR}.old
BACKUP_CRAFT_DIR="${LOCAL_BACKUPS_PATH}${LOCAL_DB_NAME}/${CRAFT_BACKUP_SUBDIR}"
BACKUP_CRAFT_DIR_OLD=${BACKUP_CRAFT_DIR}.old

# Only rotate the backup if we have a new one
if [ -d "${BACKUP_ASSETS_DIR}" ]
then
    echo "Moving backup directory ${BACKUP_ASSETS_DIR} to ${BACKUP_ASSETS_DIR_OLD}"
    rm -rf "${BACKUP_ASSETS_DIR_OLD}"
    mv "${BACKUP_ASSETS_DIR}" "${BACKUP_ASSETS_DIR_OLD}"
fi

if [ -d "${BACKUP_CRAFT_DIR}" ]
then
    echo "Moving backup directory ${BACKUP_CRAFT_DIR} to ${BACKUP_CRAFT_DIR_OLD}"
    rm -rf "${BACKUP_CRAFT_DIR_OLD}"
    mv "${BACKUP_CRAFT_DIR}" "${BACKUP_CRAFT_DIR_OLD}"
fi

# Normal exit
exit 0

