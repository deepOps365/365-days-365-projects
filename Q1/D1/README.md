# Day 1 — System Info Script

**Month 1 | Week 1 — Bash Scripting Basics**

## Task

Write a Bash script that prints system information in a clean, readable format:

- OS name and kernel version
- CPU model and number of cores
- Total and available RAM
- Disk usage (total, used, free)

---

## The Script (line by line)

```bash
OS=$(uname -o)
KERNEL=$(uname -r)
```
`uname -o` → OS name (e.g. `GNU/Linux`)  
`uname -r` → kernel version (e.g. `6.6.87.2-microsoft-standard-WSL2`)  
`$(...)` runs a command and stores the output in a variable.

```bash
CPU=$(lscpu | grep "Model name" | awk -F: '{print $2}' | xargs)
CORES=$(lscpu | grep "^CPU(s)" | awk -F: '{print $2}' | xargs)
```
`lscpu` dumps all CPU info. We pipe it through:
- `grep "Model name"` → find the right line
- `awk -F: '{print $2}'` → split by `:` and take the part after it
- `xargs` → trims leading/trailing whitespace

`^CPU(s)` — the `^` anchors to start of line, so it won't match `On-line CPU(s) list`.

```bash
RAM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
RAM_AVAIL=$(free -h | grep Mem | awk '{print $7}')
```
`free -h` shows memory in human-readable units. The `Mem:` row columns are:  
`$1`=label, `$2`=total, `$3`=used, `$4`=free, `$7`=available

```bash
DISK_TOTAL=$(df -h | grep " /$" | awk '{print $2}')
DISK_USED=$(df -h  | grep " /$" | awk '{print $3}')
DISK_FREE=$(df -h  | grep " /$" | awk '{print $4}')
```
`df -h` lists all filesystems. `grep " /$"` filters to only the root `/` mount.  
Columns: `$2`=total, `$3`=used, `$4`=free.

```bash
echo "OS          : $OS"
# ... rest of the output
```
Just printing the stored variables in a formatted layout.

---

## Usage

```bash
chmod +x system_info.sh   # make it executable (once)
./system_info.sh          # run it
```

## Sample Output

```
=================================
        SYSTEM INFO REPORT
=================================
OS          : GNU/Linux
Kernel      : 6.6.87.2-microsoft-standard-WSL2
CPU         : 11th Gen Intel(R) Core(TM) i7-1165G7 @ 2.80GHz
CPU Cores   : 8
---------------------------------
RAM Total   : 15Gi
RAM Avail   : 14Gi
---------------------------------
Disk Total  : 1007G
Disk Used   : 3.7G
Disk Free   : 953G
=================================
```
