#!/bin/bash

# Sync Backups to S3
#
# Sync local backups to an Amazon S3 bucket
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.1.3
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

# Make sure the local assets directory exists
echo "Ensuring asset directory exists at '${LOCAL_BACKUPS_PATH}'"
mkdir -p "${LOCAL_BACKUPS_PATH}"

# Initialize delete_flag variable
delete_flag=""

# Check if REMOTE_S3_DELETE is set to 'yes'
if [ "${REMOTE_S3_DELETE}" = "yes" ]; then
    delete_flag="--delete"
fi

# Sync the local backups to the Amazon S3 bucket
if [ -z "${LOCAL_AWS_PROFILE}" ] ; then
    aws s3 sync "${LOCAL_BACKUPS_PATH}" s3://"${REMOTE_S3_BUCKET}"/"${REMOTE_S3_PATH}" ${delete_flag}
else
    aws --profile="${LOCAL_AWS_PROFILE}" s3 sync "${LOCAL_BACKUPS_PATH}" s3://"${REMOTE_S3_BUCKET}"/"${REMOTE_S3_PATH}" ${delete_flag}
fi
echo "*** Synced backups to ${REMOTE_S3_BUCKET}"

# Normal exit
exit 0
