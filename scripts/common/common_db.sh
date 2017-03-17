#!/bin/bash

# Common DB
#
# Shared script to set various database-related variables
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.0.3
# @license   MIT

# Set defaults in case they have an older `.env.sh`
if [[ "${GLOBAL_DB_TABLE_PREFIX}" == "" || "${GLOBAL_DB_TABLE_PREFIX}" == "REPLACE_ME" ]] ; then
    GLOBAL_DB_TABLE_PREFIX="craft_"
fi
if [[ "${LOCAL_MYSQL_CMD}" == "" || "${LOCAL_MYSQL_CMD}" == "REPLACE_ME" ]] ; then
    LOCAL_MYSQL_CMD="mysql"
fi
if [[ "${LOCAL_MYSQLDUMP_CMD}" == "" || "${LOCAL_MYSQLDUMP_CMD}" == "REPLACE_ME" ]] ; then
    LOCAL_MYSQLDUMP_CMD="mysqldump"
fi
if [[ "${REMOTE_MYSQL_CMD}" == "" || "${REMOTE_MYSQL_CMD}" == "REPLACE_ME" ]] ; then
    REMOTE_MYSQL_CMD="mysql"
fi
if [[ "${REMOTE_MYSQLDUMP_CMD}" == "" || "${REMOTE_MYSQLDUMP_CMD}" == "REPLACE_ME" ]] ; then
    REMOTE_MYSQLDUMP_CMD="mysqldump"
fi

# Tables to exclude from the mysqldump
EXCLUDED_TABLES=(
            "assetindexdata"
            "assettransformindex"
            "cache"
            "sessions"
            "templatecaches"
            "templatecachecriteria"
            "templatecacheelements"
            )

IGNORED_TABLES_STRING=""
for TABLE in "${EXCLUDED_TABLES[@]}"
do
   IGNORED_TABLES_STRING+=" --ignore-table=${LOCAL_DB_NAME}.${GLOBAL_DB_TABLE_PREFIX}${TABLE}"
done

# Build the remote mysql credentials
REMOTE_DB_CREDS=""
if [ "${REMOTE_DB_USER}" != "" ] ; then
    REMOTE_DB_CREDS="${REMOTE_DB_CREDS}--user=${REMOTE_DB_USER} "
fi
if [ "${REMOTE_DB_PASSWORD}" != "" ] ; then
    REMOTE_DB_CREDS="${REMOTE_DB_CREDS}--password=\"${REMOTE_DB_PASSWORD}\" "
fi
if [ "${REMOTE_DB_HOST}" != "" ] ; then
    REMOTE_DB_CREDS="${REMOTE_DB_CREDS}--host=${REMOTE_DB_HOST} "
fi
if [ "${REMOTE_DB_PORT}" != "" ] ; then
    REMOTE_DB_CREDS="${REMOTE_DB_CREDS}--port=${REMOTE_DB_PORT} "
fi
# Use login-path if they have it set instead
if [ "${REMOTE_DB_LOGIN_PATH}" != "" ] ; then
    REMOTE_DB_CREDS="--login-path=${REMOTE_DB_LOGIN_PATH} "
fi
REMOTE_DB_CREDS="${REMOTE_DB_CREDS}\"${REMOTE_DB_NAME}\""

# Build the local mysql credentials
LOCAL_DB_CREDS=""
if [ "${LOCAL_DB_USER}" != "" ] ; then
    LOCAL_DB_CREDS="${LOCAL_DB_CREDS}--user=${LOCAL_DB_USER} "
fi
if [ "${LOCAL_DB_PASSWORD}" != "" ] ; then
    LOCAL_DB_CREDS="${LOCAL_DB_CREDS}--password=\"${LOCAL_DB_PASSWORD}\" "
fi
if [ "${LOCAL_DB_HOST}" != "" ] ; then
    LOCAL_DB_CREDS="${LOCAL_DB_CREDS}--host=${LOCAL_DB_HOST} "
fi
if [ "${LOCAL_DB_PORT}" != "" ] ; then
    LOCAL_DB_CREDS="${LOCAL_DB_CREDS}--port=${LOCAL_DB_PORT} "
fi
# Use login-path if they have it set instead
if [ "${LOCAL_DB_LOGIN_PATH}" != "" ] ; then
    LOCAL_DB_CREDS="--login-path=${LOCAL_DB_LOGIN_PATH} "
fi
LOCAL_DB_CREDS="${LOCAL_DB_CREDS}\"${LOCAL_DB_NAME}\""
