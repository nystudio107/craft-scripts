#!/bin/bash

# Backup Files
#
# Backup local files to a timestamped archive
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

find ${LOCAL_ROOT_PATH} -type f | grep -Ev '(\.idea|\.git)' |
    grep -v -f <(sed 's/\([.|]\)/\\\1/g; s/\?/./g ; s/\*/.*/g' ${LOCAL_ROOT_PATH}/.gitignore) |
    while IFS= read -r file ; do
        echo $file
    done

# Normal exit
exit 0

