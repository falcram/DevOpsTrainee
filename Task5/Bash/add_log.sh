#!/bin/bash

LOG_FILE="1.log"
RESP_5XX_LOG="3.log"
RESP_4XX_LOG="4.log"

while true; do
    for i in {1..5}; do
        time_to_grep_access=$(date -d "$i seconds ago" '+%d/%b/%Y:%H:%M:%S')
        time_to_grep_error=$(date -d "$i seconds ago" '+%Y/%m/%d %H:%M:%S')
        grep "$time_to_grep_access" "$LOG_FILE" | awk '$10 ~ /4[0-9]{2}/ { print }' >> "$RESP_4XX_LOG" #awk "$10 ~ /5[0-9]{2}/ { print }" >> "$RESP_5XX_LOG"
        grep "$time_to_grep_access" "$LOG_FILE" | awk '$10 ~ /5[0-9]{2}/ { print }' >> "$RESP_5XX_LOG" #awk "$10 ~ /5[0-9]{2}/ { print }" >> "$RESP_5XX_LOG"

        #grep "$time_to_grep_error" "$LOG_FILE" | awk '{ print $8 }' #awk "$10 ~ /4[0-9]{2}/ { print }" #>> "$RESP_4XX_LOG"    
    done
done
