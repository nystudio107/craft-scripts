#!/bin/bash

# Sync Files
#
# Sync local files from a timestamped archive
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

BACKUP_FILES_DIR_PATH="${LOCAL_BACKUPS_PATH}${FILES_BACKUP_SUBDIR}/"

# Restore the files dirs via rsync
for DIR in "${LOCAL_DIRS_TO_BACKUP[@]}"
do
    rsync -F -L -a -z "${REMOTE_ROOT_PATH}${DIR}" "${LOCAL_ROOT_PATH}" --progress
    echo "*** Sync'd files to ${DIR}"
done

# Normal exit
exit 0

