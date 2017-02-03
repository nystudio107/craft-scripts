#!/bin/bash

# Clear Caches
#
# Remove the craft cache directories and database tables
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-permissions
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
                "templatecaches"
                )

# Make sure the `.env.sh` exists
if [[ ! -f ".env.sh" ]] ; then
    echo 'File ".env.sh" is missing, aborting.'
    exit
fi

source ".env.sh"

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
        $LOCAL_MYSQL_CMD --user=${LOCAL_DB_USER} --password=${LOCAL_DB_PASSWORD} ${LOCAL_DB_NAME} -e \
            "DELETE FROM $FULLTABLE"
    done
echo "*** Caches cleared"
