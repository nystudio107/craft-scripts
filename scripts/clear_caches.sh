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
    if [[ ! -f "${DIR}/${INCLUDE_FILE}" ]] ; then
        echo "File ${DIR}/${INCLUDE_FILE} is missing, aborting."
        exit 1
    fi
    source "${DIR}/${INCLUDE_FILE}"
done

# Functions
function clear_mysql_cache() {
    for TABLE in ${CRAFT_CACHE_TABLES[@]}
    do
        FULLTABLE=${GLOBAL_DB_TABLE_PREFIX}${TABLE}
        echo "Emptying cache table $FULLTABLE"
        $LOCAL_MYSQL_CMD $LOCAL_DB_CREDS -e \
            "DELETE FROM $FULLTABLE" &>/dev/null
    done
}
function clear_pgsql_cache() {
    echo ${LOCAL_DB_HOST}:${LOCAL_DB_PORT}:${LOCAL_DB_NAME}:${LOCAL_DB_USER}:${LOCAL_DB_PASSWORD} > "${TMP_DB_DUMP_CREDS_PATH}"
    chmod 600 "${TMP_DB_DUMP_CREDS_PATH}"
    for TABLE in ${CRAFT_CACHE_TABLES[@]}
    do
        FULLTABLE=${GLOBAL_DB_TABLE_PREFIX}${TABLE}
        echo "Emptying cache table $FULLTABLE"
        PGPASSFILE="${TMP_DB_DUMP_CREDS_PATH}" $LOCAL_PSQL_CMD $LOCAL_DB_CREDS -c \
            "DELETE FROM $FULLTABLE"
    done
    rm "${TMP_DB_DUMP_CREDS_PATH}"
}

# Source the correct file for the database driver
case "$GLOBAL_DB_DRIVER" in
    ( 'mysql' ) source "${DIR}/common/common_mysql.sh" ;;
    ( 'pgsql' ) source "${DIR}/common/common_pgsql.sh" ;;
    ( * )
        echo "Environment variable GLOBAL_DB_DRIVER was neither 'mysql' nor 'pgsql'. Aborting."
        exit 1 ;;
esac

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
    if [[ -d "${FULLPATH}" ]] ; then
        echo "Removing cache dir ${FULLPATH}"
        rm -rf "${FULLPATH}"
    else
        echo "Creating directory ${FULLPATH}"
        mkdir "${FULLPATH}"
        chmod -R $WRITEABLE_DIR_PERMS "${FULLPATH}"
    fi
done

# Empty the cache tables
case "$GLOBAL_DB_DRIVER" in
    ( 'mysql' ) clear_mysql_cache ;;
    ( 'pgsql' ) clear_pgsql_cache ;;
esac

# Clear the FastCGI Cache dir
if [[ "${LOCAL_FASTCGI_CACHE_DIR}" != "" ]] ; then
    echo "Emptying FastCGI Cache at ${LOCAL_FASTCGI_CACHE_DIR}"
    rm -rf "${LOCAL_FASTCGI_CACHE_DIR}"*
fi

# Clear the redis cache
if [[ "${LOCAL_REDIS_DB_ID}" != "" ]] ; then
    echo "Emptying redis cache for database ${LOCAL_REDIS_DB_ID}"
    if [ "${LOCAL_REDIS_PASSWORD}" != "" ] ; then
        echo -e "auth ${LOCAL_REDIS_PASSWORD}\nselect ${LOCAL_REDIS_DB_ID}\nflushdb" | redis-cli
    else
        echo -e "select ${LOCAL_REDIS_DB_ID}\nflushdb" | redis-cli
    fi
fi

echo "*** Caches cleared"

# Normal exit
exit 0
