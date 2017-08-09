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
        echo "File ${DIR}/${INCLUDE_FILE} is missing, aborting."
        exit 1
    fi
done
if [ "${GLOBAL_DB_DRIVER}" == "mysql" ] ; then
    source "${DIR}/common/common_mysql.sh"
fi
if [ "${GLOBAL_DB_DRIVER}" == "pgsql" ] ; then
    source "${DIR}/common/common_pgsql.sh"
fi

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
if [ "${GLOBAL_DB_DRIVER}" == "mysql" ] ; then
    for TABLE in ${CRAFT_CACHE_TABLES[@]}
        do
            FULLTABLE=${GLOBAL_DB_TABLE_PREFIX}${TABLE}
            echo "Emptying cache table $FULLTABLE"
            $LOCAL_MYSQL_CMD $LOCAL_DB_CREDS -e \
                "DELETE FROM $FULLTABLE" &>/dev/null
        done
fi
if [ "${GLOBAL_DB_DRIVER}" == "pgsql" ] ; then
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
fi

# Clear the FastCGI Cache dir
if [ "${LOCAL_FASTCGI_CACHE_DIR}" != "" ] ; then
    echo "Emptying FastCGI Cache at ${LOCAL_FASTCGI_CACHE_DIR}"
    rm -rf "${LOCAL_FASTCGI_CACHE_DIR}"*
fi

# Clear the redis cache
if [ "${LOCAL_REDIS_DB_ID}" != "" ] ; then
    echo "Emptying redis cache for database ${LOCAL_REDIS_DB_ID}"
    echo -e "select ${LOCAL_REDIS_DB_ID}\nflushdb" | redis-cli
fi

echo "*** Caches cleared"

# Normal exit
exit 0
