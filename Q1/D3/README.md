# Day 3 — Backup Script

**Month 1 | Week 1 — Bash Scripting Basics**

## Task

Write a Bash script that compresses a folder into a `.tar.gz` archive with a timestamp in the filename.

```
backup_myfolder_2026-04-03_21-30-00.tar.gz
```

---

## The Script (line by line)

```bash
SOURCE="${1}"
DEST="${2:-.}"
```
`$1` = folder you want to back up (required).  
`$2` = where to save the archive. If not given, defaults to `.` (current folder).

```bash
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
```
`date` prints the current date/time. The `+"%Y-%m-%d_%H-%M-%S"` part is the format:
- `%Y` → 4-digit year (2026)
- `%m` → month (04)
- `%d` → day (03)
- `%H-%M-%S` → hours, minutes, seconds

Result example: `2026-04-03_21-30-00`

```bash
ARCHIVE_NAME="backup_$(basename "$SOURCE")_$TIMESTAMP.tar.gz"
```
Builds the filename. `basename` strips the path and keeps just the folder name.  
e.g. `~/projects/myapp` → `myapp`  
Full result: `backup_myapp_2026-04-03_21-30-00.tar.gz`

```bash
tar -czf "$DEST/$ARCHIVE_NAME" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"
```
The core command. Flags:
- `c` → **c**reate a new archive
- `z` → compress with g**z**ip (makes it `.gz`)
- `f` → the next argument is the **f**ilename of the archive
- `-C <dir>` → change into this directory before archiving

**Why `-C`?**  
Without it, if you pass `../D2/test_folder` the archive stores the full relative path `D2/test_folder/` inside. With `-C` we split the path:
- `dirname "../D2/test_folder"` → `../D2` (parent dir — tar cd's here first)
- `basename "../D2/test_folder"` → `test_folder` (only this gets stored inside the archive)

So when you extract, you get `test_folder/` cleanly instead of `D2/test_folder/`.

---

## `tar` Flag Reference

### Operation flags (what to do)
| Flag | Meaning |
|---|---|
| `c` | Create a new archive |
| `x` | Extract files from an archive |
| `t` | List contents of an archive (without extracting) |
| `r` | Append files to an existing archive |
| `u` | Update — append files newer than the copy in archive |
| `d` | Compare archive with filesystem (find differences) |

### Compression flags (format)
| Flag | Format | Extension |
|---|---|---|
| `z` | gzip | `.tar.gz` or `.tgz` |
| `j` | bzip2 (slower, better compression) | `.tar.bz2` |
| `J` | xz (slowest, best compression) | `.tar.xz` |
| _(none)_ | no compression | `.tar` |

### Modifier flags
| Flag | Meaning |
|---|---|
| `f` | Next argument is the archive filename |
| `v` | Verbose — print each file being processed |
| `p` | Preserve file permissions |
| `C` | Change to this directory before extracting |
| `--exclude=PATTERN` | Skip files matching the pattern |

### Common combos
```bash
# Create compressed archive (what we use)
tar -czf archive.tar.gz folder/

# Extract into current directory
tar -xzf archive.tar.gz

# Extract into a specific directory
tar -xzf archive.tar.gz -C /tmp/

# List contents without extracting
tar -tzf archive.tar.gz

# Verbose create (see each file as it's added)
tar -czvf archive.tar.gz folder/

# Exclude a subfolder while backing up
tar -czf archive.tar.gz folder/ --exclude=folder/node_modules
```

```bash
echo "Backup created: $DEST/$ARCHIVE_NAME"
```
Confirms the backup was created and shows the full path.

---

## Usage

```bash
chmod +x backup.sh                        # make it executable (once)

./backup.sh myfolder                      # backup to current directory
./backup.sh myfolder ~/backups            # backup to a specific destination
```

## Sample Output

```
Backup created: ./backup_myfolder_2026-04-03_21-30-00.tar.gz
```

To verify the archive contents:
```bash
tar -tzf backup_myfolder_2026-04-03_21-30-00.tar.gz
```
