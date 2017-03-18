#!/bin/bash

# Clear Caches
#
# Remove the craft cache directories and database tables
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.0.2
# @license   MIT

# The permissions for files & directories that need to be writeable
WRITEABLE_DIR_PERMS=775  # `-rwxrwxr-x`

# Local directories relative to LOCAL_ROOT_PATH that should be removed to clear the cache
CRAFT_CACHE_DIRS=(
                "craft/storage/runtime/cache"
                "craft/storage/runtime/compiled_templates"
                "craft/storage/runtime/state"
                )

# Craft Database tables to be emptied to clear the cache
CRAFT_CACHE_TABLES=(
                "cache"
                "templatecaches"
                )

# Get the directory of the currently executing script
DIR="$(dirname "${BASH_SOURCE[0]}")"

# Make sure the `.env.sh` exists
if [[ ! -f "${DIR}/.env.sh" ]] ; then
    echo 'File "${DIR}/.env.sh" is missing, aborting.'
    exit
fi
source "${DIR}/.env.sh"

# Make sure the `common_db.sh` exists
if [[ ! -f "${DIR}/common/common_db.sh" ]] ; then
    echo 'File "${DIR}/common/common_db.sh" is missing, aborting.'
    exit
fi
source "${DIR}/common/common_db.sh"

# Make sure the `common_env.sh` exists
if [[ ! -f "${DIR}/common/common_env.sh" ]] ; then
    echo 'File "${DIR}/common/common_env.sh" is missing, aborting.'
    exit
fi
source "${DIR}/common/common_env.sh"

# Delete the cache dirs
for DIR in ${CRAFT_CACHE_DIRS[@]}
    do
        FULLPATH="${LOCAL_ROOT_PATH}${DIR}"
        if [ -d "${FULLPATH}" ]
        then
            echo "Removing cache dir ${FULLPATH}"
            rm -rf "${FULLPATH}"
        else
            echo "Creating directory ${FULLPATH}"
            mkdir "${FULLPATH}"
            chmod -R $WRITEABLE_DIR_PERMS "${FULLPATH}"
        fi
    done

# Empty the cache tables
for TABLE in ${CRAFT_CACHE_TABLES[@]}
    do
        FULLTABLE=${GLOBAL_DB_TABLE_PREFIX}${TABLE}
        echo "Emptying cache table $FULLTABLE"
        $LOCAL_MYSQL_CMD $LOCAL_DB_CREDS -e \
            "DELETE FROM $FULLTABLE"
    done
echo "*** Caches cleared"
