# Craft-Scripts Changelog

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
