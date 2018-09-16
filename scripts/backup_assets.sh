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
echo "Ensuring backup directory exists at '${BACKUP_ASSETS_DIR_PATH}'"
mkdir -p "${BACKUP_ASSETS_DIR_PATH}"

# Backup the asset dir files via rsync
for DIR in "${LOCAL_ASSETS_DIRS[@]}"
do
    rsync -F -L -a -z --progress "${LOCAL_ASSETS_PATH}${DIR}" "${BACKUP_ASSETS_DIR_PATH}"
    echo "*** Backed up assets from ${LOCAL_ASSETS_PATH}${DIR}"
done


# Make sure the Craft files backup directory exists
echo "Ensuring backup directory exists at '${BACKUP_CRAFT_DIR_PATH}'"
mkdir -p "${BACKUP_CRAFT_DIR_PATH}"

# Backup the Craft-specific dir files via rsync
for DIR in "${LOCAL_CRAFT_FILE_DIRS[@]}"
do
    rsync -F -L -a -z --progress "${LOCAL_CRAFT_FILES_PATH}${DIR}" "${BACKUP_CRAFT_DIR_PATH}"
    echo "*** Backed up assets from ${LOCAL_CRAFT_FILES_PATH}${DIR}"
done

# Normal exit
exit 0
