# Day 1 — System Info Script

**Month 1 | Week 1 — Bash Scripting Basics**

## Task

Write a **single Bash script** that prints the following system information in a clean, readable format:

- Operating System name and version
- CPU model and number of cores
- Total and available RAM
- Disk usage (total, used, free)

---

## Understanding the Commands

### `uname` — OS information
`uname` stands for "Unix Name". It prints basic system info.

```
$ uname          → just prints "Linux"
$ uname -s       → kernel name (Linux)
$ uname -r       → kernel release (e.g. 6.6.87.2-microsoft-standard-WSL2)
$ uname -o       → OS name (GNU/Linux)
```

**What you need:** OS name + kernel version. Try combining flags: `uname -so`

---

### `lscpu` — CPU information
`lscpu` stands for "list CPU". It dumps everything about your processor.  
Your output had a lot of noise. You only need two lines from it:

```
Model name:   11th Gen Intel(R) Core(TM) i7-1165G7 @ 2.80GHz
CPU(s):       8
```

**How to extract a specific line?** Use `grep`.  
`grep` searches for a pattern in text. Example:

```bash
lscpu | grep "Model name"
# Output: Model name:  11th Gen Intel(R) Core(TM) i7-1165G7 @ 2.80GHz
```

The `|` (pipe) passes output of one command into another.

But you still get the label "Model name:" in there. To strip it and get only the value, use `awk`:

```bash
lscpu | grep "Model name" | awk -F: '{print $2}'
```

`awk -F:` means "split each line by `:` as the separator", then `$2` is the second part (after the colon).

**Hint for core count:** grep for `^CPU(s):` — the `^` means "start of line", so it won't accidentally match `On-line CPU(s) list`.

---

### `free` — RAM information
`free` shows memory usage. Your output:

```
               total        used        free      shared  buff/cache   available
Mem:        16216280      725484    15242136        3724      460820    15490796
```

The numbers are in kilobytes. Add `-h` flag to get human-readable (MB/GB):

```bash
free -h
```

You need the **Mem:** row only. Use `grep`:

```bash
free -h | grep Mem
```

Now you have one row with multiple columns. `awk` can pick specific columns by position (space-separated by default):

- `$1` = "Mem:"
- `$2` = total
- `$7` = available

```bash
free -h | grep Mem | awk '{print $2}'    # total RAM
free -h | grep Mem | awk '{print $7}'    # available RAM
```

---

### `df` — Disk usage
`df` stands for "disk free". Your output had many filesystems listed. You want the main one — the root filesystem mounted at `/`.

Add `-h` for human-readable sizes:

```bash
df -h
```

To get only the root `/` row:

```bash
df -h | grep " /$"
```

The `" /$"` pattern matches lines that **end with** ` /` (the mount point), isolating the root disk.

From that row:
- `$2` = total size
- `$3` = used
- `$4` = available

---

## Building the Script — Step by Step

### Step 1: Create the file
```bash
touch system_info.sh
```

### Step 2: Open it and add the shebang
```bash
#!/bin/bash
```
This tells the OS: "run this file using Bash". It must be the very first line.

### Step 3: Capture each value into a variable
Use the `VAR=$(...)` syntax. For example:
```bash
OS=$(uname -o)
```
Now `$OS` holds "GNU/Linux". Do this for each piece of info you need.

**Your turn — figure out the variable for each:**
- [ ] OS name + kernel version → hint: combine two `uname` calls or flags
- [ ] CPU model → hint: `lscpu | grep "Model name" | awk ...`
- [ ] CPU core count → hint: `lscpu | grep "^CPU(s)" | awk ...`
- [ ] Total RAM → hint: `free -h | grep Mem | awk ...`
- [ ] Available RAM → hint: same line, different column
- [ ] Disk total/used/free → hint: `df -h | grep " /$" | awk ...`

### Step 4: Print with echo
```bash
echo "=== System Info ==="
echo "OS      : $OS"
# add the rest...
```

### Step 5: Make it executable and run it
```bash
chmod +x system_info.sh
./system_info.sh
```

`chmod +x` adds execute permission to the file. Without it, Bash won't let you run it directly.

---

## Checklist

---

## Checklist

- [ ] Script runs without errors
- [ ] OS info is displayed
- [ ] CPU model and core count are displayed
- [ ] RAM (total + available) is displayed
- [ ] Disk usage is displayed
- [ ] Output is clean and human-readable

---

## Files

| File | Description |
|---|---|
| `system_info.sh` | Your Bash script |
