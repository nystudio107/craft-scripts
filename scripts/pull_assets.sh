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

# Make sure the `.env.sh` exists
if [[ ! -f ".env.sh" ]] ; then
    echo 'File ".env.sh" is missing, aborting.'
    exit
fi
source ".env.sh"

# Make sure the `common_env.sh` exists
if [[ ! -f "common/common_env.sh" ]] ; then
    echo 'File "common/common_env.sh" is missing, aborting.'
    exit
fi
source "common/common_env.sh"

for DIR in "${LOCAL_ASSETS_DIRS[@]}"
do
    rsync -a -z -e "ssh -p ${REMOTE_SSH_PORT}" "${REMOTE_SSH_LOGIN}:${REMOTE_ASSETS_PATH}${DIR}" "${LOCAL_ASSETS_PATH}" --progress
    echo "*** Synced assets from ${DIR}"
done
