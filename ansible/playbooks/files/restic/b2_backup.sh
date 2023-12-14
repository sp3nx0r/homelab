#!/bin/bash
set -eou
source /etc/restic/b2.env

sqlite3 "${VAULTWARDEN_DIR}"/db.sqlite3 ".backup ${VAULTWARDEN_DIR}/db.sqlite3.backup"
restic --limit-upload 2000 backup /storage/backup /storage/docker /storage/plex-data
restic --limit-upload 2000 backup "${VAULTWARDEN_DIR}"
restic --limit-upload 2000 backup /storage/datastore-minio/tfstate
restic --verbose --keep-last 5 --keep-daily 6 --keep-weekly 3 forget
