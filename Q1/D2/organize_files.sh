#!/usr/bin/env bash

# organize_files.sh
# Usage: ./organize_files.sh <folder>

TARGET="${1:-.}"

for file in "$TARGET"/*; do
    # skip if not a regular file
    [ -f "$file" ] || continue

    filename=$(basename "$file")

    # get extension; if none, use "no_extension"
    if echo "$filename" | grep -q '\.'; then
        ext="${filename##*.}"
    else
        ext="no_extension"
    fi

    # create subfolder and move the file into it
    mkdir -p "$TARGET/$ext"
    mv "$file" "$TARGET/$ext/$filename"

    echo "Moved: $filename -> $ext/"
done
