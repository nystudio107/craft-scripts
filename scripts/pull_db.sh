#!/bin/bash

# Make sure the `.env.sh` exists
if [[ ! -f ".env.sh" ]] ; then
    echo 'File ".env.sh" is missing, aborting.'
    exit
fi

source ".env.sh"

# Temporary db dump path (remote & local)
TMP_DB_PATH="/tmp/craft-db-dump.sql"

ssh $REMOTE_SSH_LOGIN "mysqldump -u '$REMOTE_DB_USER' -p'$REMOTE_DB_PASSWORD' '$REMOTE_DB_NAME' > $TMP_DB_PATH"
scp -- $REMOTE_SSH_LOGIN:"$TMP_DB_PATH" "$TMP_DB_PATH"
$LOCAL_MYSQL_CMD -u "$LOCAL_DB_USER" -p"$LOCAL_DB_PASSWORD" "$LOCAL_DB_NAME" < "$TMP_DB_PATH"

echo "*** Restored database from $REMOTE_DB_NAME"
