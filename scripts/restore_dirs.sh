#!/bin/bash

# Restore Files
#
# Restore local files from a timestamped archive
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

BACKUP_FILES_DIR_PATH="${LOCAL_BACKUPS_PATH}${LOCAL_DB_NAME}/${FILES_BACKUP_SUBDIR}/"

# Make sure the asset backup directory exists
if [[ ! -d "${BACKUP_FILES_DIR_PATH}" ]] ; then
    echo "No backup directory ${BACKUP_FILES_DIR_PATH}"
    exit 1
fi

# Restore the files dirs via rsync
for DIR in "${LOCAL_DIRS_TO_BACKUP[@]}"
do
    rsync -F -L -a -z --progress "${BACKUP_FILES_DIR_PATH}${DIR}" "${DIR}"
    echo "*** Restored files to ${DIR}"
done

# Normal exit
exit 0
