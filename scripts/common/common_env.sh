#!/bin/bash

# Common Env
#
# Shared script to set various environment-related variables
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.0.4
# @license   MIT

# gzip/gunzip compression commands
GZIP_CMD="gzip -f"
ZCAT_CMD="zcat"

# Set defaults in case they have an older `.env.sh`
if [[ "${REMOTE_SSH_PORT}" == "" || "${REMOTE_SSH_PORT}" == "REPLACE_ME" ]] ; then
    REMOTE_SSH_PORT="22"
fi

if [[ "${LOCAL_BACKUPS_PATH}" == "" || "${LOCAL_BACKUPS_PATH}" == "REPLACE_ME" ]] ; then
    LOCAL_BACKUPS_PATH="/tmp/"
fi
if [[ "${LOCAL_BACKUPS_MAX_AGE}" == "" || "${LOCAL_BACKUPS_MAX_AGE}" == "REPLACE_ME" ]] ; then
    LOCAL_BACKUPS_MAX_AGE=90
fi
