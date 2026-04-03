#!/usr/bin/env bash

# backup.sh
# Usage: ./backup.sh <folder_to_backup> [destination_folder]

SOURCE="${1}"
DEST="${2:-.}"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="backup_$(basename "$SOURCE")_$TIMESTAMP.tar.gz"

tar -czf "$DEST/$ARCHIVE_NAME" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"

echo "Backup created: $DEST/$ARCHIVE_NAME"
