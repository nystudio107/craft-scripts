# craft-scripts
Shell scripts to manage permissions, asset syncing, cache clearing, and database syncing between Craft CMS environments

## Overview

There are several scripts included in `craft-scripts`, each of which perform different functions. They all use a shared `.env.sh` to function. This `.env.sh` should be created on each environment where you wish to run the `craft-scripts`, and it should be excluded from your git repo via `.gitignore`.

### set_perms.sh

The `set_perms.sh` script sets the Craft CMS install file permissions in a strict manner, to assist in hardening Craft CMS installs.

See [Hardening Craft CMS Permissions](https://nystudio107.com/blog/hardening-craft-cms-permissions) for a detailed writeup.

Note: if you use `git`, and change file permissions on your remote server, you may encounter git complaining about `overwriting existing local changes` when you try to deploy. This is because git considers changing the executable flag to be a change in the file, so it thinks you changed the files on your server (and the changes are not checked into your git repo).

To fix this, we just need to tell git to ignore permission changes on the server. You can change the `fileMode` setting for `git` on your server, telling it to ignore permission changes of the files on the server:

    git config --global core.fileMode false

See the [git-config man page](https://git-scm.com/docs/git-config#git-config-corefileMode) for details.

The other way to fix this is to set the permission using `set_perms.sh` in `local` dev, and then check the files into your git repo. This will cause them to be saved with the correct permissions in your git repo to begin with.

### clear_caches.sh

The `clear_caches.sh` script clears the Craft CMS caches by removing all of the `craft/storage/runtime/` cache dirs, as well as emptying the `craft_templatecaches` db table.

If you want to add this to your Forge / DeployBot / Buddy.works deploy script so that caches are auto-cleared on deploy, set up the `.env.sh` on your remote server(s) and then add this to your deploy script:

    cd scripts && ./clear_caches.sh

The above assumes that the current working directory is the project root already.

![Screenshot](resources/img/forge_clear_caches.png)

### pull_db.sh

The `pull_db.sh` script pulls down a database dump from a remote server, and then dumps it into your local database.

The db dumps that `craft-scripts` does will exclude tables that are temporary/cache tables that we don't want in our backups/restores, such as the `templatecaches` table.

See [Database & Asset Syncing Between Environments in Craft CMS](https://nystudio107.com/blog/database-asset-syncing-between-environments-in-craft-cms) for a detailed writeup.

If you're using `mysql 5.6` or later, you’ll note the warning from mysql (this is [not an issue if you’re using MariaDB](https://mariadb.com/kb/en/mariadb/mysql_config_editor-compatibility/)):

    mysql: [Warning] Using a password on the command line interface can be insecure.

What the `craft-scripts` is doing isn’t any less secure than if you typed it on the command line yourself; everything sent over the wire is always encrypted via ssh. However, you can set up `login-path` to store your credentials in an encrypted file as per the [Passwordless authentication using mysql_config_editor with MySQL 5.6](https://opensourcedbms.com/dbms/passwordless-authentication-using-mysql_config_editor-with-mysql-5-6/) article.

If you set `LOCAL_DB_LOGIN_PATH` or `REMOTE_DB_LOGIN_PATH` it will use `--login-path=` for your db credentials on the respective environments instead of sending them in via the commandline.

For example, for my `local` dev setup:

    mysql_config_editor set --login-path=localdev --user=homestead --host=localhost --port=3306 --password

...and then enter the password for that user. And then in the `.env.sh` I set it to:

    LOCAL_DB_LOGIN_PATH="localdev"

...and it will use my stored, encrypted credentials instead of passing them in via commandline. You can also set this up on your remote server, and then set it via `REMOTE_DB_LOGIN_PATH`

### pull_assets.sh

The `pull_assets.sh` script pulls down an arbitrary number of asset directories from a remote server, since we keep client-uploadable assets out of the git repo

See [Database & Asset Syncing Between Environments in Craft CMS](https://nystudio107.com/blog/database-asset-syncing-between-environments-in-craft-cms) for a detailed writeup.

### Setting it up

1. Download or clone the `craft-scripts` git repo
2. Copy the `scripts` directory into the root directory of your Craft CMS project
3. Duplicate the `example.env.sh` file, and rename it to `.env.sh`
4. Add `.env.sh` to your `.gitignore` file
5. Then open up the `.env.sh` file into your favorite editor, and replace `REPLACE_ME` with the appropriate settings.

All configuration is done in the `.env.sh` file, rather than in the scripts themselves. This is is so that the same scripts can be used in multiple environments such as `local` dev, `staging`, and `live` production without modification. Just create a `.env.sh` file in each environment, and keep it out of your git repo via `.gitignore`.


#### Global Settings

All settings that are prefaced with `GLOBAL_` apply to **all** environments.

`GLOBAL_DB_TABLE_PREFIX` is the Craft database table prefix, usually `craft_`

#### Local Settings

All settings that are prefaced with `LOCAL_` refer to the local environment where the script will be run, **not** your `local` dev environment.

`LOCAL_ROOT_PATH` is the absolute path to the root of your local Craft install, with a trailing `/` after it.

`LOCAL_ASSETS_PATH` is the relative path to your local assets directories, with a trailing `/` after it.

`LOCAL_CHOWN_USER` is the user that is the owner of your entire Craft install.

`LOCAL_CHOWN_GROUP` is your webserver's group, usually either `nginx` or `apache`.

`LOCAL_WRITEABLE_DIRS` is a quoted list of directories relative to `LOCAL_ROOT_PATH` that should be writeable by your webserver.

`LOCAL_ASSETS_DIRS` is a quoted list of asset directories relative to `LOCAL_ASSETS_PATH` that you want to pull down from the remote server. It's done this way in case you wish to sync some asset directories, but not others. If you want to pull down all asset directories in `LOCAL_ASSETS_PATH`, just leave one blank quoted string in this array

`LOCAL_DB_NAME` is the name of the local mysql Craft CMS database

`LOCAL_DB_PASSWORD` is the password for the local mysql Craft CMS database

`LOCAL_DB_USER` is the user for the local mysql Craft CMS database

`LOCAL_DB_HOST` is the host name of the local mysql database host. This is normally `localhost`

`LOCAL_DB_PORT` is the port number of the local mysql database host. This is normally `3306`

`LOCAL_MYSQL_CMD` is the command for the local mysql executable, normally just `mysql`. It is provided because some setups like MAMP require a full path to a copy of `mysql` inside of the application bundle.

`LOCAL_MYSQLDUMP_CMD` is the command for the local mysqldump executable, normally just `mysqldump`. It is provided because some setups like MAMP require a full path to a copy of `mysqldump` inside of the application bundle.

##### Using mysql within a local docker container

`LOCAL_MYSQL_CMD` which is normally just `mysql`, is prepended with `docker exec -i CONTAINER_NAME` to execute the command within the container. (Example: `docker exec -i container_mysql_1 mysql`)

`LOCAL_MYSQLDUMP_CMD` which is normally just `mysqldump`, is prepended with `docker exec CONTAINER_NAME` to execute the command within the container. (Example: `docker exec container_mysql_1 mysqldump`)

#### Remote Settings

All settings that are prefaced with `REMOTE_` refer to the remote environment where assets and the database will be pulled from.

`REMOTE_SSH_LOGIN` is your ssh login to the remote server, e.g.: `user@domain.com`

`REMOTE_SSH_PORT` is the port to use for ssh on the remote server. This is normally `22`

`REMOTE_ROOT_PATH` is the absolute path to the root of your Craft install on the remote server, with a trailing `/` after it.

`REMOTE_ASSETS_PATH` is the relative path to the remote assets directories, with a trailing `/` after it.

`REMOTE_DB_NAME` is the name of the remote mysql Craft CMS database

`REMOTE_DB_PASSWORD` is the password for the remote mysql Craft CMS database

`REMOTE_DB_USER` is the user for the remote mysql Craft CMS database

`REMOTE_DB_HOST` is the host name of the remote mysql database host. This is normally `localhost`

`REMOTE_DB_PORT` is the port number of the remote mysql database host. This is normally `3306`

`REMOTE_MYSQL_CMD` is the command for the local mysql executable, normally just `mysql`.

`REMOTE_MYSQLDUMP_CMD` is the command for the local mysqldump executable, normally just `mysqldump`.

Brought to you by [nystudio107](https://nystudio107.com/)
