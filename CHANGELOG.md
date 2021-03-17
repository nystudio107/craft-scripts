# Craft-Scripts Changelog

## 1.2.13 - 2020.10.20
### Changed
* Removed the MySQL-specific `--set-gtid-purged=OFF` to the `common_mysql.sh` from the mysqldump command options

## 1.2.12 - 2020.10.20
### Added
* Added `--set-gtid-purged=OFF` to the `common_mysql.sh` to avoid permissions issues with some database dumps
* Added support for a `LOCAL_AWS_PROFILE` variable, which lets you specify which AWS named profile to connect to S3 with.
* Add in-folder `.gitignore` to ensure that `.env.sh` is ignored

### Fixed
* Fix `TMP_LOG_PATH` for local db backups

## 1.2.11 - 2020.08.11
### Changed
* Added `--no-tablespaces` to the mysqldump command options to work around changes in MySQL

## 1.2.10 - 2018.11.23
### Changed
* Don’t dump permission/ownership info for postgres

## 1.2.9 - 2018.10.29
### Changed
* Add `templatecachequeries` to the db tables excluded from database dumps

## 1.2.8 - 2018.08.20
### Changed
* Refactor out to functions thanks to `preposthuman `

## 1.2.7 - 2018.05.22
### Changed
* Code cleanup and refactoring thanks to `preposthuman `

## 1.2.6 - 2018.01.17
### Changed
* Fixed an issue with the backup path for the `backup_dir.sh` script (again)
* Made `web/cpresources` a default `LOCAL_WRITEABLE_DIRS` in the `craft3-example.env.sh`

### Added
* Added `restore_assets.sh` restores the assets from the backup that has been created with `backup_assets.sh`.
* Added `restore_dirs.sh` restores the dirs from the backup that has been created with `backup_dirs.sh`

## 1.2.5 - 2017.11.14
### Changed
* Fixed an issue with the backup path for the `backup_dir.sh` script 

## 1.2.4 - 2017.10.28
### Added
* Added separate example starter `*-example.env.sh` for Craft 2.x & Craft 3.x
* Added composer support
* Updated README.md

## 1.2.3 - 2017.09.07
### Changed
* Fixed an issue where remote db pulls wouldn't exclude db tables that should have been ignored (such as the templatecaches table)

## 1.2.2 - 2017.08.08
### Changed
* Added support for pulling db dumps directly from hosted MySQL/Postgres servers (needed for Heroku and other environments)
* Output from `clear_caches.sh` is suppressed for the table dropping (to prevent spurious "table doesn't exist" errors)
* Support for proper Postgres cache table purging

## 1.2.1 - 2017.07.23
### Changed
* Fixed the `clear_caches.sh` script for `mysql`

## 1.2.0 - 2017.07.18
### Added
* Added `postgres` database support for Craft 3

### Changed
* Updated `README.md`

## 1.1.7 - 2017.06.28
### Added
* Added support for backups to an Amazon S3 bucket sub-folder
* Added section links to the README.md

## 1.1.6 - 2017.06.15
### Changed
* Added support for clearing the FastCGI Cache in `clear_caches.sh` via `LOCAL_FASTCGI_CACHE_DIR`

## 1.1.5 - 2017.06.12
### Changed
* The `pull_assets.sh` script now deletes local assets that have been removed from the remote
* Added support for clearing the Redis cache in `clear_caches.sh` via `LOCAL_REDIS_DB_ID`

## 1.1.4 - 2017.04.07
### Changed
* Added the `backup_files.sh` script to backup arbitrary directories of files
* Added `rsync -F` to allow for excluding files/directories via `.rsync-filter` files
* Fixed an unparsed error message if one of the include scripts is missing
* Revised `README.md`

## 1.1.3 - 2017.03.22
### Changed
* Changed `zcat` to `gunzip -c` for MaxOS X compatibility

## 1.1.2 - 2017.03.22
### Added
* Added the `sync_backups_to_s3.sh` script to sync backups to an Amazon S3 bucket
* Pull all the backups on `pull_backups.sh`

## 1.1.1 - 2017.03.20
### Added
* Added the `restore_db.sh` script to make restoring local databases easier

### Changed
* Revised `README.md` to document `restore_db.sh`

## 1.1.0 - 2017.03.19
### Added
* Added the ability to run the scripts from anywhere (no need to `cd` to the directory)
* Added `backup_db.sh` for doing local, rotating database backups
* Added local asset backup via `backup_assets.sh`
* Added the ability to pull backups down from the remote server via `pull_backups.sh`
* Added pulling of the Craft `userphotos` & `rebrand` directories via `pull_assets.sh`
* Added support for `.gz` compressing the database before transfering it, to speed things up
* Added support for restoring directly from a `.gz` compressed database dump
* Added additional arguments to the `mysqldump`
* Added `common/defaults.sh` to set reasonable defaults for many settings
* Added the ability to change the `craft` folder location
* Added an `example.gitignore` that you can use in your Craft CMS projects
* Added `com.example.launch_daemon.plist` as a Mac [Launch Daemon](https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html) example

### Changed
* Revised `README.md` to document the changes/new features
* Code cleanup & refactoring

## 1.0.3 - 2017.03.15
### Added
* Added support for `login-path` to store your mysql db credentials in an encrypted file, and thus avoid `mysql: [Warning] Using a password on the command line interface can be insecure.` warnings
* Added `LOCAL_DB_HOST` and `LOCAL_DB_PORT` to the `.env.sh`
* Added `REMOTE_MYSQL_CMD` and `REMOTE_MYSQLDUMP_CMD` to the `.env.sh`
* Added the `crontab-helper` file you can add to your `crontab` as a crib sheet
* Added the `cache` table as one to delete/ignore

### Changed
* Made the scripts more tolerant of missing settings (perhaps due to old `.env.sh` files)
* Refactored common code out to `common/common_db.sh` and `common/common_env.sh`
* Updated the `README.md` with information about `fileMode`
* Updated the `README.md` with information about `login-path`

## 1.0.2 - 2017.02.03
### Added
* Exclude cache/temporary tables from db dumps (both local and remote)
* Move to a global setting for `GLOBAL_DB_TABLE_PREFIX`
* Harmonized the comments
* Harmonized the {} usage for quoted or combined variables

## 1.0.1 - 2017.01.24
### Added
* Broke out the changelog to CHANGELOG.md
* Added mysql host and port constants

### Changed
* Update pull_db.sh to use --flags

## 1.0.0 - 2016.12.05

### Added
* Initial release

Brought to you by [nystudio107](https://nystudio107.com/)
