#!/usr/bin/env bash

# disk_alert.sh
# Alerts if any disk partition exceeds the usage threshold.
# Usage: ./disk_alert.sh [threshold]

THRESHOLD="${1:-80}"

df -h | tail -n +2 | while read -r line; do
    usage=$(echo "$line" | awk '{print $5}' | tr -d '%')
    mount=$(echo "$line"  | awk '{print $6}')

    if [[ "$usage" -ge "$THRESHOLD" ]]; then
        echo "[ALERT] $mount is at ${usage}% usage"
    else
        echo "[ OK ]  $mount is at ${usage}% usage"
    fi
done
