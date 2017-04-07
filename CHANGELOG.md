# Craft-Scripts Changelog

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
