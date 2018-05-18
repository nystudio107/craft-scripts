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
    if [[ ! -f "${DIR}/${INCLUDE_FILE}" ]] ; then
        echo "File ${DIR}/${INCLUDE_FILE} is missing, aborting."
        exit 1
    fi
    source "${DIR}/${INCLUDE_FILE}"
done

# Make sure the local assets directory exists
echo "Ensuring asset directory exists at '${LOCAL_BACKUPS_PATH}'"
mkdir -p "${LOCAL_BACKUPS_PATH}"

# Pull down the backup dir files via rsync
rsync -F -L -a -z -e "ssh -p ${REMOTE_SSH_PORT}" --progress "${REMOTE_SSH_LOGIN}:${REMOTE_BACKUPS_PATH}" "${LOCAL_BACKUPS_PATH}"
echo "*** Synced backups from ${REMOTE_BACKUPS_PATH}"

# Normal exit
exit 0
