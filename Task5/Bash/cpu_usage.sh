#!/bin/bash
LOG_FILE="/var/www/task3/cpu/cpu_usage.txt"

while true; do
    cpu_id=$(top -n 1 -b | grep "Cpu(s)" | grep -P -o "\d+\.?\d*(?= id)")
    cpu=$(echo "100.0 - $cpu_id" | bc)
    echo "$cpu" > "$LOG_FILE"
    sleep 3
done
