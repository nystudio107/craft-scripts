#!/bin/bash

# Set Permissions
#
# Set the proper, hardened permissions for an install
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

# The permissions for all files & directories in the Craft CMS install
GLOBAL_DIR_PERMS=755     # `-rwxr-xr-x`
GLOBAL_FILE_PERMS=644    # `-rw-r--r--`

# The permissions for files & directories that need to be writeable
WRITEABLE_DIR_PERMS=775  # `-rwxrwxr-x`
WRITEABLE_FILE_PERMS=664 # `-rw-rw-r--`

# Set project permissions
echo "Setting base permissions for the project ${LOCAL_ROOT_PATH}"
chown -R ${LOCAL_CHOWN_USER}:${LOCAL_CHOWN_GROUP} "${LOCAL_ROOT_PATH}"
chmod -R ${GLOBAL_DIR_PERMS} "${LOCAL_ROOT_PATH}"
find "${LOCAL_ROOT_PATH}" -type f ! -name "*.sh" -exec chmod $GLOBAL_FILE_PERMS {} \;

for DIR in ${LOCAL_WRITEABLE_DIRS[@]}
do
    FULLPATH=${LOCAL_ROOT_PATH}${DIR}
    if [[ -d "${FULLPATH}" ]] ; then
        echo "Fixing permissions for ${FULLPATH}"
        chmod -R $WRITEABLE_DIR_PERMS "${FULLPATH}"
        find "${FULLPATH}" -type f ! -name "*.sh" -exec chmod $WRITEABLE_FILE_PERMS {} \;
    else
        echo "Creating directory ${FULLPATH}"
        mkdir "${FULLPATH}"
        chmod -R $WRITEABLE_DIR_PERMS "${FULLPATH}"
    fi
done

# Normal exit
exit 0
