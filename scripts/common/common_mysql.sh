#!/bin/bash

# Common mysql
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
   LOCAL_IGNORED_DB_TABLES_STRING+="--ignore-table=${LOCAL_DB_NAME}.${GLOBAL_DB_TABLE_PREFIX}${TABLE} "
   REMOTE_IGNORED_DB_TABLES_STRING+="--ignore-table=${REMOTE_DB_NAME}.${GLOBAL_DB_TABLE_PREFIX}${TABLE} "
done

# Additional arguments for mysqldump
MYSQLDUMP_ADDITIONAL_ARGS=""
MYSQLDUMP_ADDITIONAL_ARGS+="--add-drop-table "
MYSQLDUMP_ADDITIONAL_ARGS+="--no-tablespaces "
MYSQLDUMP_ADDITIONAL_ARGS+="--comments "
MYSQLDUMP_ADDITIONAL_ARGS+="--create-options "
MYSQLDUMP_ADDITIONAL_ARGS+="--dump-date "
MYSQLDUMP_ADDITIONAL_ARGS+="--no-autocommit "
MYSQLDUMP_ADDITIONAL_ARGS+="--routines "
MYSQLDUMP_ADDITIONAL_ARGS+="--set-charset "
MYSQLDUMP_ADDITIONAL_ARGS+="--triggers "

# Arguments to dump just the schema
MYSQLDUMP_SCHEMA_ARGS=""
MYSQLDUMP_SCHEMA_ARGS+="--single-transaction "
MYSQLDUMP_SCHEMA_ARGS+="--no-data "
MYSQLDUMP_SCHEMA_ARGS+=$MYSQLDUMP_ADDITIONAL_ARGS

# Arguments to dump just the data
MYSQLDUMP_DATA_ARGS=""
MYSQLDUMP_DATA_ARGS+="--no-create-info "
MYSQLDUMP_DATA_ARGS+=$MYSQLDUMP_ADDITIONAL_ARGS

# Build the remote mysql credentials
REMOTE_DB_CREDS=""
if [[ -n "${REMOTE_DB_USER}" ]] ; then
    REMOTE_DB_CREDS+="--user=${REMOTE_DB_USER} "
fi
if [[ -n "${REMOTE_DB_PASSWORD}" ]] ; then
    REMOTE_DB_CREDS+="--password=${REMOTE_DB_PASSWORD} "
fi
if [[ -n "${REMOTE_DB_HOST}" ]] ; then
    REMOTE_DB_CREDS+="--host=${REMOTE_DB_HOST} "
fi
if [[ -n "${REMOTE_DB_PORT}" ]] ; then
    REMOTE_DB_CREDS+="--port=${REMOTE_DB_PORT} "
fi
# Use login-path if they have it set instead
if [[ -n "${REMOTE_DB_LOGIN_PATH}" ]] ; then
    REMOTE_DB_CREDS="--login-path=${REMOTE_DB_LOGIN_PATH} "
fi
REMOTE_DB_CREDS+="${REMOTE_DB_NAME}"

# Build the local mysql credentials
LOCAL_DB_CREDS=""
if [[ -n "${LOCAL_DB_USER}" ]] ; then
    LOCAL_DB_CREDS+="--user=${LOCAL_DB_USER} "
fi
if [[ -n "${LOCAL_DB_PASSWORD}" ]] ; then
    LOCAL_DB_CREDS+="--password=${LOCAL_DB_PASSWORD} "
fi
if [[ -n "${LOCAL_DB_HOST}" ]] ; then
    LOCAL_DB_CREDS+="--host=${LOCAL_DB_HOST} "
fi
if [[ -n "${LOCAL_DB_PORT}" ]] ; then
    LOCAL_DB_CREDS+="--port=${LOCAL_DB_PORT} "
fi
# Use login-path if they have it set instead
if [[ -n "${LOCAL_DB_LOGIN_PATH}" ]] ; then
    LOCAL_DB_CREDS="--login-path=${LOCAL_DB_LOGIN_PATH} "
fi
LOCAL_DB_CREDS+="${LOCAL_DB_NAME}"
