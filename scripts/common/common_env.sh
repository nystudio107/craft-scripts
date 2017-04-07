#!/bin/bash

# Common Env
#
# Shared script to set various environment-related variables
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.1.0
# @license   MIT

# Craft paths; ; paths should always have a trailing /
LOCAL_CRAFT_FILES_PATH=${LOCAL_ROOT_PATH}"${GLOBAL_CRAFT_PATH}storage/"
REMOTE_CRAFT_FILES_PATH=${REMOTE_ROOT_PATH}"${GLOBAL_CRAFT_PATH}storage/"

# Commands to output database dumps, using gunzip -c instead of zcat for MacOS X compatibility
DB_ZCAT_CMD="gunzip -c"
DB_CAT_CMD="cat"

# For nicer user messages
PLURAL_CHAR="s"

# Sub-directories for the various backup types
DB_BACKUP_SUBDIR="db"
ASSETS_BACKUP_SUBDIR="assets"
CRAFT_BACKUP_SUBDIR="craft"
FILES_BACKUP_SUBDIR="files"
