#!/bin/bash

# Pull Backups
#
# Pull backups down from a remote to local
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

# Make sure the local assets directory exists
if [[ ! -d "${LOCAL_BACKUPS_PATH}" ]] ; then
    echo "Creating asset directory ${LOCAL_BACKUPS_PATH}"
    mkdir -p "${LOCAL_BACKUPS_PATH}"
fi

# Pull down the backup dir files via rsync
rsync -F -L -a -z -e "ssh -p ${REMOTE_SSH_PORT}" "${REMOTE_SSH_LOGIN}:${REMOTE_BACKUPS_PATH}" "${LOCAL_BACKUPS_PATH}" --progress
echo "*** Synced backups from ${REMOTE_BACKUPS_PATH}"

# Normal exit
exit 0

