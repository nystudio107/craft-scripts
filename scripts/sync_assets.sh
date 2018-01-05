#!/bin/bash

# Sync Assets
#
# Sync local assets
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



# Sync the asset dir files via rsync
for DIR in "${LOCAL_ASSETS_DIRS[@]}"
do
    rsync -F -L -a -z "${REMOTE_ASSETS_PATH}${DIR}" "${LOCAL_ASSETS_PATH}" --progress
    echo "*** Sync'd assets to ${LOCAL_ASSETS_PATH}${DIR}"
done


# Sync the Craft-specific dir files via rsync
for DIR in "${LOCAL_CRAFT_FILE_DIRS[@]}"
do
    rsync -F -L -a -z "${REMOTE_CRAFT_FILES_PATH}${DIR}" "${LOCAL_CRAFT_FILES_PATH}" --progress
    echo "*** Sync'd assets to ${LOCAL_CRAFT_FILES_PATH}${DIR}"
done

# Normal exit
exit 0

