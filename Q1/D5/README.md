# Day 5 — Disk Usage Alert

**Month 1 | Week 1 — Bash Scripting Basics**

## Task

Write a Bash script that checks all disk partitions and prints an alert for any that exceed 80% usage.

```
[ OK ]    /     is at 4%  usage (3.7G / 1007G)
[ALERT]   /data is at 87% usage (870G / 1000G)
```

---

## The Script (line by line)

```bash
THRESHOLD="${1:-80}"
```
Alert threshold in percent. Defaults to `80` if you don't pass one.

```bash
df -h | tail -n +2 | while read -r line; do
    usage=$(echo "$line" | awk '{print $5}' | tr -d '%')
    mount=$(echo "$line"  | awk '{print $6}')
```
Three things chained:
- `df -h` → lists all disk partitions in human-readable sizes
- `tail -n +2` → skip the header row (explained below)
- `while read -r line` → reads each remaining line as a single string

`awk '{print $5}'` → grabs column 5, which is the `Use%` value (e.g. `87%`)  
`tr -d '%'` → deletes the `%` character, leaving just the number `87`  
`awk '{print $6}'` → grabs column 6, the mount point (e.g. `/` or `/mnt/data`)

**Why `tail -n +2`?**  
`df -h` output looks like this:
```
Filesystem      Size  Used Avail Use% Mounted on     ← line 1 (header)
/dev/sdb        1007G 3.7G  953G   4% /              ← line 2
tmpfs            7.9G    0  7.9G   0% /dev/shm        ← line 3
...
```
`tail -n +2` means "start from line **2** onwards" — it drops line 1.  
Without this, `awk` would grab `Use%` as the usage value, which can't be compared as a number.

`df -h` columns: `Filesystem | Size | Used | Avail | Use% | Mounted on`

```bash
    if [[ "$usage" -ge "$THRESHOLD" ]]; then
        echo "[ALERT] $mount is at ${usage}% usage"
    else
        echo "[ OK ]  $mount is at ${usage}% usage"
    fi
```
`-ge` = greater than or equal to. If usage hits the threshold, print an alert.

---

## Usage

```bash
chmod +x disk_alert.sh

./disk_alert.sh          # uses 80% as threshold
./disk_alert.sh 90       # alert only above 90%
./disk_alert.sh 5        # low threshold to test alerts
```

## Sample Output

```
[ OK ]    /                        is at 4%   (3.7G / 1007G)
[ OK ]    /boot/efi                is at 1%   (6.1M / 512M)
[ALERT]   /mnt/external            is at 91%  (455G / 500G)
```
