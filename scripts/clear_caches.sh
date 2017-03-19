#!/bin/bash

# Clear Caches
#
# Remove the craft cache directories and database tables
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
            "common/common_db.sh"
            )
for INCLUDE_FILE in "${INCLUDE_FILES[@]}"
do
    if [ -f "${DIR}/${INCLUDE_FILE}" ]
    then
        source "${DIR}/${INCLUDE_FILE}"
    else
        echo 'File "${DIR}/${INCLUDE_FILE}" is missing, aborting.'
        exit 1
    fi
done

# The permissions for files & directories that need to be writeable
WRITEABLE_DIR_PERMS=775  # `-rwxrwxr-x`

# Local directories relative to LOCAL_CRAFT_FILES_PATH that should be removed to clear the cache
CRAFT_CACHE_DIRS=(
                "runtime/cache"
                "runtime/compiled_templates"
                "runtime/state"
                )

# Craft Database tables to be emptied to clear the cache
CRAFT_CACHE_TABLES=(
                "cache"
                "templatecaches"
                )

# Delete the cache dirs
for DIR in ${CRAFT_CACHE_DIRS[@]}
    do
        FULLPATH="${LOCAL_CRAFT_FILES_PATH}${DIR}"
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

# Normal exit
exit 0
