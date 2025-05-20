#!/bin/bash

LOG_FILE="1.log"
CLEAN_LOG="2.log"
RESP_5XX_LOG="3.log"
RESP_4XX_LOG="4.log"

while true; do
    date '+%d/%b/%Y:%H:%M:%S' >> "$LOG_FILE"
    for i in {1..5}; do
        time_to_grep_access=$(date -d "$i seconds ago" '+%d/%b/%Y:%H:%M:%S')
        time_to_grep_error=$(date -d "$i seconds ago" '+%Y/%m/%d %H:%M:%S')
        grep "$time_to_grep_access" /var/log/nginx/access.log | sed 's/^/access_log: /' | tee -a  "$LOG_FILE" | awk '
            $10 ~ /4[0-9]{2}/ { print >> "'"$RESP_4XX_LOG"'" }
            $10 ~ /5[0-9]{2}/ { print >> "'"$RESP_5XX_LOG"'" }
            '
        grep "$time_to_grep_error" /var/log/nginx/error.log | sed 's/^/error_log: /' >> "$LOG_FILE"    
    done
    
    file_size=$(stat "$LOG_FILE" | grep -P -o "(?<=Size: )\d+")
    #echo  "$file_size"
    if [ "$file_size" -ge "300000" ]; then
        logstring=""
        logstring+=$(date '+%Y/%m/%d %H:%M:%S')
        logstring+=" lines_deleted:"
        logstring+=$(wc -l "$LOG_FILE" | awk '{print $1}')
        echo "$logstring" >> "$CLEAN_LOG"
        tmp=$(tail -n 5 "$LOG_FILE")
        echo "$tmp" > "$LOG_FILE"
    fi
    sleep 5
done


