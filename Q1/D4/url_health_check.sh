#!/usr/bin/env bash

# url_health_check.sh
# Usage: ./url_health_check.sh urls.txt

URLS_FILE="${1:-urls.txt}"

while read -r url; do
    # skip empty lines and comments
    [[ -z "$url" || "$url" == \#* ]] && continue

    status=$(curl -o /dev/null -s -w "%{http_code}" --max-time 5 "$url")

    if [[ "$status" -ge 200 && "$status" -lt 400 ]]; then
        echo "[ UP ]  $url  ($status)"
    else
        echo "[ DOWN ]  $url  ($status)"
    fi

done < "$URLS_FILE"
