#!/bin/bash

# Restore Assets
#
# Restore local assets
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.2.6
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
    if [[ ! -f "${DIR}/${INCLUDE_FILE}" ]] ; then
        echo "File ${DIR}/${INCLUDE_FILE} is missing, aborting."
        exit 1
    fi
    source "${DIR}/${INCLUDE_FILE}"
done

# Set the backup directory paths
BACKUP_ASSETS_DIR_PATH="${LOCAL_BACKUPS_PATH}${LOCAL_DB_NAME}/${ASSETS_BACKUP_SUBDIR}/"
BACKUP_CRAFT_DIR_PATH="${LOCAL_BACKUPS_PATH}${LOCAL_DB_NAME}/${CRAFT_BACKUP_SUBDIR}/"

# Make sure the asset backup directory exists
if [[ ! -d "${BACKUP_ASSETS_DIR_PATH}" ]] ; then
    echo "No backup directory ${BACKUP_ASSETS_DIR_PATH}"
    exit 1
fi

# Restore the asset dir files via rsync
for DIR in "${LOCAL_ASSETS_DIRS[@]}"
do
    rsync -F -L -a -z --progress "${BACKUP_ASSETS_DIR_PATH}${DIR}" "${LOCAL_ASSETS_PATH}"
    echo "*** Restored assets to ${LOCAL_ASSETS_PATH}${DIR}"
done


# Restore the Craft-specific dir files via rsync
for DIR in "${LOCAL_CRAFT_FILE_DIRS[@]}"
do
    rsync -F -L -a -z --progress "${BACKUP_CRAFT_DIR_PATH}${DIR}" "${LOCAL_CRAFT_FILES_PATH}"
    echo "*** Restored assets to ${LOCAL_CRAFT_FILES_PATH}${DIR}"
done

# Normal exit
exit 0
