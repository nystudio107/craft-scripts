#!/bin/bash

# Backup Assets
#
# Backup local assets
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
BACKUP_ASSETS_DIR_PATH="${LOCAL_BACKUPS_PATH}${LOCAL_DB_NAME}/${ASSETS_BACKUP_SUBDIR}/"
BACKUP_CRAFT_DIR_PATH="${LOCAL_BACKUPS_PATH}${LOCAL_DB_NAME}/${CRAFT_BACKUP_SUBDIR}/"

# Make sure the asset backup directory exists
if [[ ! -d "${BACKUP_ASSETS_DIR_PATH}" ]] ; then
    echo "Creating backup directory ${BACKUP_ASSETS_DIR_PATH}"
    mkdir -p "${BACKUP_ASSETS_DIR_PATH}"
fi

# Backup the asset dir files via rsync
for DIR in "${LOCAL_ASSETS_DIRS[@]}"
do
    rsync -F -L -a -z "${LOCAL_ASSETS_PATH}${DIR}" "${BACKUP_ASSETS_DIR_PATH}" --progress
    echo "*** Backed up assets from ${LOCAL_ASSETS_PATH}${DIR}"
done


# Make sure the Craft files backup directory exists
if [[ ! -d "${BACKUP_CRAFT_DIR_PATH}" ]] ; then
    echo "Creating backup directory ${BACKUP_CRAFT_DIR_PATH}"
    mkdir -p "${BACKUP_CRAFT_DIR_PATH}"
fi

# Backup the Craft-specific dir files via rsync
for DIR in "${LOCAL_CRAFT_FILE_DIRS[@]}"
do
    rsync -F -L -a -z "${LOCAL_CRAFT_FILES_PATH}${DIR}" "${BACKUP_CRAFT_DIR_PATH}" --progress
    echo "*** Backed up assets from ${LOCAL_CRAFT_FILES_PATH}${DIR}"
done

# Normal exit
exit 0

