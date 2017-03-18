#!/bin/bash

# Set Permissions
#
# Set the proper, hardened permissions for an install
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.0.2
# @license   MIT

# The permissions for all files & directories in the Craft CMS install
GLOBAL_DIR_PERMS=755     # `-rwxr-xr-x`
GLOBAL_FILE_PERMS=644    # `-rw-r--r--`

# The permissions for files & directories that need to be writeable
WRITEABLE_DIR_PERMS=775  # `-rwxrwxr-x`
WRITEABLE_FILE_PERMS=664 # `-rw-rw-r--`

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

echo "Setting base permissions for the project ${LOCAL_ROOT_PATH}"
chown -R ${LOCAL_CHOWN_USER}:${LOCAL_CHOWN_GROUP} "${LOCAL_ROOT_PATH}"
chmod -R ${GLOBAL_DIR_PERMS} "${LOCAL_ROOT_PATH}"
find "${LOCAL_ROOT_PATH}" -type f ! -name "*.sh" -exec chmod $GLOBAL_FILE_PERMS {} \;

for DIR in ${LOCAL_WRITEABLE_DIRS[@]}
    do
        FULLPATH=${LOCAL_ROOT_PATH}${DIR}
        if [ -d "${FULLPATH}" ]
        then
            echo "Fixing permissions for ${FULLPATH}"
            chmod -R $WRITEABLE_DIR_PERMS "${FULLPATH}"
            find "${FULLPATH}" -type f ! -name "*.sh" -exec chmod $WRITEABLE_FILE_PERMS {} \;
        else
            echo "Creating directory ${FULLPATH}"
            mkdir "${FULLPATH}"
            chmod -R $WRITEABLE_DIR_PERMS "${FULLPATH}"
        fi
    done
