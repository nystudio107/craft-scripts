# Craft Scripts Environment
# @author    nystudio107
# @copyright Copyright (c) 2016 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts-environment
# @since     1.0.0
# @license   MIT
#
# This file should be renamed to '.env.sh' and it should reside in the
# `scripts` directory.  Add '.env.sh' to your .gitignore.

# Local environmental config for nystudio107 Craft scripts

# -- LOCAL settings --

# Local path constants; paths should always have a trailing /
LOCAL_ROOT_PATH="REPLACE_ME"
LOCAL_ASSETS_PATH=$LOCAL_ROOT_PATH"REPLACE_ME"

# Local user & group that should own the Craft CMS install
LOCAL_CHOWN_USER="admin"
LOCAL_CHOWN_GROUP="apache"

# Local directories that should be writeable by the $CHOWN_GROUP
LOCAL_WRITEABLE_DIRS=(
                "craft/config"
                "craft/storage"
                "public/assets"
                )

# Local asset directories to sync with remote assets
LOCAL_ASSETS_DIRS=(
                ""
                )

# Local database constants
LOCAL_DB_NAME="REPLACE_ME"
LOCAL_DB_PASSWORD="REPLACE_ME"
LOCAL_DB_USER="REPLACE_ME"
LOCAL_MYSQL_CMD="REPLACE_ME"

# -- REMOTE settings --

# Remote ssh credentials
REMOTE_SSH_LOGIN="REPLACE_ME"

# Remote path constants; paths should always have a trailing /
REMOTE_ROOT_PATH="REPLACE_ME"
REMOTE_ASSETS_PATH=$LOCAL_ROOT_PATH"REPLACE_ME"

# Remote database constants
REMOTE_DB_NAME="REPLACE_ME"
REMOTE_DB_PASSWORD="REPLACE_ME"
REMOTE_DB_USER="REPLACE_ME"
REMOTE_MYSQL_CMD="REPLACE_ME"
