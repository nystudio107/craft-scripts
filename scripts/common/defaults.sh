# Craft Scripts Defaults
#
# Default settings for Craft scripts
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.0.4
# @license   MIT

# -- GLOBAL settings --

GLOBAL_DB_TABLE_PREFIX="craft_"

# -- LOCAL settings --

# Local path constants; paths should always have a trailing /
LOCAL_ROOT_PATH="REPLACE_ME"
LOCAL_ASSETS_PATH=${LOCAL_ROOT_PATH}"REPLACE_ME"

# Local user & group that should own the Craft CMS install
LOCAL_CHOWN_USER="admin"
LOCAL_CHOWN_GROUP="apache"

# Local directories relative to LOCAL_ROOT_PATH that should be writeable by the $CHOWN_GROUP
LOCAL_WRITEABLE_DIRS=(
                "craft/storage"
                "public/assets"
                )

# Local asset directories relative to LOCAL_ASSETS_PATH that should be synched with remote assets
LOCAL_ASSETS_DIRS=(
                ""
                )

# Local database constants
LOCAL_DB_NAME="REPLACE_ME"
LOCAL_DB_PASSWORD="REPLACE_ME"
LOCAL_DB_USER="REPLACE_ME"
LOCAL_DB_HOST="localhost"
LOCAL_DB_PORT="3306"

# If are using mysql 5.6.10 or later and you have `login-path` setup as per:
# https://opensourcedbms.com/dbms/passwordless-authentication-using-mysql_config_editor-with-mysql-5-6/
# you can use it instead of the above LOCAL_DB_* constants; otherwise leave this blank
LOCAL_DB_LOGIN_PATH=""

# The `mysql` and `mysqldump` commands to run locally
LOCAL_MYSQL_CMD="mysql"
LOCAL_MYSQLDUMP_CMD="mysqldump"

# Local backups path; paths should always have a trailing /
LOCAL_BACKUPS_PATH="/tmp/"

# The maximum age of local backups in days; backups older than this will be automatically removed
LOCAL_BACKUPS_MAX_AGE=90

# -- REMOTE settings --

# Remote ssh credentials, user@domain.com and Remote SSH Port
REMOTE_SSH_LOGIN="REPLACE_ME"
REMOTE_SSH_PORT="22"

# Remote path constants; paths should always have a trailing /
REMOTE_ROOT_PATH="REPLACE_ME"
REMOTE_ASSETS_PATH=${REMOTE_ROOT_PATH}"REPLACE_ME"

# Remote database constants
REMOTE_DB_NAME="REPLACE_ME"
REMOTE_DB_PASSWORD="REPLACE_ME"
REMOTE_DB_USER="REPLACE_ME"
REMOTE_DB_HOST="localhost"
REMOTE_DB_PORT="3306"

# If are using mysql 5.6.10 or later and you have `login-path` setup as per:
# https://opensourcedbms.com/dbms/passwordless-authentication-using-mysql_config_editor-with-mysql-5-6/
# you can use it instead of the above REMOTE_DB_* constants; otherwise leave this blank
REMOTE_DB_LOGIN_PATH=""

# The `mysql` and `mysqldump` commands to run remotely
REMOTE_MYSQL_CMD="mysql"
REMOTE_MYSQLDUMP_CMD="mysqldump"
