# Day 4 — URL Health Checker

**Month 1 | Week 1 — Bash Scripting Basics**

## Task

Write a Bash script that reads a list of URLs from a file, checks if each one is up or down, and prints the result.

```
[ UP ]    https://www.google.com        (200)
[ UP ]    https://www.github.com        (301)
[ DOWN ]  https://httpbin.org/status/404  (404)
[ DOWN ]  https://httpbin.org/status/500  (500)
```

---

## The Script (line by line)

```bash
URLS_FILE="${1:-urls.txt}"
```
Takes the filename as an argument. If none given, defaults to `urls.txt`.

```bash
while read -r url; do
    [[ -z "$url" || "$url" == \#* ]] && continue
    ...
done < "$URLS_FILE"
```
Reads the file line by line. Each line is stored in `$url`.  
`-r` = raw mode, prevents backslashes from being interpreted.  
`< "$URLS_FILE"` = feeds the file as input to the loop.

The empty/comment check: skip the line if it's empty (`-z`) or starts with `#`. `continue` jumps to the next iteration.

```bash
[[ -z "$url" || "$url" == \#* ]] && continue
```
Skip the line if it's empty (`-z`) or starts with `#` (comment). `continue` jumps to the next iteration.

```bash
status=$(curl -o /dev/null -s -w "%{http_code}" --max-time 5 "$url")
```
The key command. `curl` flags used:
- `-o /dev/null` → throw away the response body (we don't need it)
- `-s` → silent mode, no progress bar
- `-w "%{http_code}"` → print only the HTTP status code (200, 404, etc.)
- `--max-time 5` → give up after 5 seconds (handles dead servers)

```bash
if [[ "$status" -ge 200 && "$status" -lt 400 ]]; then
    echo "[ UP ]  $url  ($status)"
else
    echo "[ DOWN ]  $url  ($status)"
fi
```
2xx and 3xx = up. 4xx, 5xx, or no response (000) = down.

---

## Usage

```bash
chmod +x url_health_check.sh

./url_health_check.sh             # uses urls.txt by default
./url_health_check.sh myurls.txt  # use a custom file
```

`urls.txt` format — one URL per line, `#` for comments:
```
https://www.google.com
https://www.github.com
https://httpbin.org/status/404
https://httpbin.org/status/500
# this is ignored
```

> Use `httpbin.org/status/<code>` as a reliable way to test specific HTTP status codes.

## HTTP Status Code Cheatsheet

| Range | Meaning |
|---|---|
| 2xx | Success (200 OK, 201 Created…) |
| 3xx | Redirect (301, 302…) — still reachable |
| 4xx | Client error (404 Not Found, 403 Forbidden…) |
| 5xx | Server error (500, 503…) |
| 000 | No response / timeout |
