#!/bin/bash

# Common pgsql
#
# Shared script to set various database-related variables
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.2.0
# @license   MIT

LOCAL_IGNORED_DB_TABLES_STRING=""
REMOTE_IGNORED_DB_TABLES_STRING=""
for TABLE in "${EXCLUDED_DB_TABLES[@]}"
do
   LOCAL_IGNORED_DB_TABLES_STRING+="--exclude-table-data=${LOCAL_DB_SCHEMA}.${GLOBAL_DB_TABLE_PREFIX}${TABLE} "
   REMOTE_IGNORED_DB_TABLES_STRING+="--exclude-table-data=${REMOTE_DB_SCHEMA}.${GLOBAL_DB_TABLE_PREFIX}${TABLE} "
done

# Additional arguments for mysqldump
PG_DUMP_ADDITIONAL_ARGS=""
PG_DUMP_ADDITIONAL_ARGS+="--no-password "
PG_DUMP_ADDITIONAL_ARGS+="--if-exists "
PG_DUMP_ADDITIONAL_ARGS+="--clean "
PG_DUMP_ADDITIONAL_ARGS+="--no-owner "
PG_DUMP_ADDITIONAL_ARGS+="--no-privileges "
PG_DUMP_ADDITIONAL_ARGS+="--no-acl "

# Arguments to dump just the data
PG_DUMP_ARGS=""
PG_DUMP_ARGS+=$PG_DUMP_ADDITIONAL_ARGS

# Build the remote psql credentials
REMOTE_DB_CREDS=""
if [[ -n "${REMOTE_DB_NAME}" ]] ; then
    REMOTE_DB_CREDS+="--dbname=${REMOTE_DB_NAME} "
fi
if [[ -n "${REMOTE_DB_USER}" ]] ; then
    REMOTE_DB_CREDS+="--username=${REMOTE_DB_USER} "
fi
if [[ -n "${REMOTE_DB_HOST}" ]] ; then
    REMOTE_DB_CREDS+="--host=${REMOTE_DB_HOST} "
fi
if [[ -n "${REMOTE_DB_PORT}" ]] ; then
    REMOTE_DB_CREDS+="--port=${REMOTE_DB_PORT} "
fi

# Build the local psql credentials
LOCAL_DB_CREDS=""
if [[ -n "${LOCAL_DB_NAME}" ]] ; then
    LOCAL_DB_CREDS+="--dbname=${LOCAL_DB_NAME} "
fi
if [[ -n "${LOCAL_DB_USER}" ]] ; then
    LOCAL_DB_CREDS+="--username=${LOCAL_DB_USER} "
fi
if [[ -n "${LOCAL_DB_HOST}" ]] ; then
    LOCAL_DB_CREDS+="--host=${LOCAL_DB_HOST} "
fi
if [[ -n "${LOCAL_DB_PORT}" ]] ; then
    LOCAL_DB_CREDS+="--port=${LOCAL_DB_PORT} "
fi
