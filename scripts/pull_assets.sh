#!/bin/bash

# Pull Assets
#
# Pull remote assets down from a remote to local
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-permissions
# @since     1.0.2
# @license   MIT

# Get the directory of the currently executing script
DIR="$(dirname "${BASH_SOURCE[0]}")"

# Make sure the `.env.sh` exists
if [[ ! -f "${DIR}/.env.sh" ]] ; then
    echo 'File "${DIR}/.env.sh" is missing, aborting.'
    exit
fi
source "${DIR}/.env.sh"

# Make sure the `common_env.sh` exists
if [[ ! -f "${DIR}/common/common_env.sh" ]] ; then
    echo 'File "${DIR}/common/common_env.sh" is missing, aborting.'
    exit
fi
source "${DIR}/common/common_env.sh"

for DIR in "${LOCAL_ASSETS_DIRS[@]}"
do
    rsync -a -z -e "ssh -p ${REMOTE_SSH_PORT}" "${REMOTE_SSH_LOGIN}:${REMOTE_ASSETS_PATH}${DIR}" "${LOCAL_ASSETS_PATH}" --progress
    echo "*** Synced assets from ${DIR}"
done
