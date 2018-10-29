#!/bin/bash

# Common DB
#
# Shared script to set various database-related variables
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.2.0
# @license   MIT

# Tables to exclude from the db dump
EXCLUDED_DB_TABLES=(
            "assetindexdata"
            "assettransformindex"
            "cache"
            "sessions"
            "templatecaches"
            "templatecachecriteria"
            "templatecacheelements"
            "templatecachequeries"
            )

TMP_DB_DUMP_CREDS_PATH="/tmp/craftscripts.creds"
