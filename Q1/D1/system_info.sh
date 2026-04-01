#!/usr/bin/bash

# ── Gather values ──────────────────────────────────────────
OS=$(uname -o)
KERNEL=$(uname -r)
CPU=$(lscpu | grep "Model name" | awk -F: '{print $2}' | xargs)
CORES=$(lscpu | grep "^CPU(s)" | awk -F: '{print $2}' | xargs)
RAM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
RAM_AVAIL=$(free -h | grep Mem | awk '{print $7}')
DISK_TOTAL=$(df -h | grep " /$" | awk '{print $2}')
DISK_USED=$(df -h | grep " /$" | awk '{print $3}')
DISK_FREE=$(df -h | grep " /$" | awk '{print $4}')

# ── Print report ───────────────────────────────────────────
echo "================================="
echo "        SYSTEM INFO REPORT       "
echo "================================="
echo "OS          : $OS"
echo "Kernel      : $KERNEL"
echo "CPU         : $CPU"
echo "CPU Cores   : $CORES"
echo "---------------------------------"
echo "RAM Total   : $RAM_TOTAL"
echo "RAM Avail   : $RAM_AVAIL"
echo "---------------------------------"
echo "Disk Total  : $DISK_TOTAL"
echo "Disk Used   : $DISK_USED"
echo "Disk Free   : $DISK_FREE"
echo "================================="