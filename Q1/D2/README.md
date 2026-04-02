# Day 2 — File Organizer Script

**Month 1 | Week 1 — Bash Scripting Basics**

## Task

Write a Bash script that sorts all files in a folder into subfolders based on their extension.

```
Before:               After:
  downloads/            downloads/
    photo.jpg     →       jpg/photo.jpg
    notes.txt     →       txt/notes.txt
    resume.pdf    →       pdf/resume.pdf
    README        →       no_extension/README
```

---

## The Script (line by line)

```bash
TARGET="${1:-.}"
```
`$1` is the folder you pass in. If you don't pass anything, use `.` (current folder).

```bash
for file in "$TARGET"/*; do
```
Loop over every item inside the folder.

```bash
    [ -f "$file" ] || continue
```
If it's not a regular file (e.g. it's a subfolder), skip it.

```bash
    filename=$(basename "$file")
```
Strip the folder path — keep just the filename. e.g. `downloads/photo.jpg` → `photo.jpg`

```bash
    if echo "$filename" | grep -q '\.'; then
        ext="${filename##*.}"
    else
        ext="no_extension"
    fi
```
Check if the filename has a dot in it.
- If yes → grab everything after the last dot → that's the extension (`jpg`, `txt`, etc.)
- If no → use `no_extension` as the folder name

`${filename##*.}` means: strip everything from the start up to and including the last dot.

```bash
    mkdir -p "$TARGET/$ext"
    mv "$file" "$TARGET/$ext/$filename"
```
Create the subfolder (safe to run even if it already exists), then move the file into it.

---

## Usage

```bash
chmod +x organize_files.sh        # make it executable (once)

./organize_files.sh               # organize current folder
./organize_files.sh ~/downloads   # organize a specific folder
./organize_files.sh test_folder   # use the included test_folder
```
