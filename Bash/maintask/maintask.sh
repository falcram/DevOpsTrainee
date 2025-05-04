#!/bin/bash

URL="https://www.youtube.com/"

while true; do

    status=$(curl -s -I "$URL" | grep HTTP | awk '{print $2}' | grep -P "2\d\d")
    tcp_status=$(nc -zv www.youtube.com 443 2>&1 | grep -o succeeded)
    #echo "$tcp_status"
    #curl -s -I "https://www.youtube.com/" | grep HTTP | awk '{print $2}'
    if [ ! -z "$status" ]; then
        log=$(date '+%d/%b/%Y:%H:%M:%S')
        log+=" $URL доступен по http, получен статус код $status"
        echo "$log" >> access.log
    fi

    if [ ! -z "$tcp_status" ]; then
        log_tcp=$(date '+%d/%b/%Y:%H:%M:%S')
        log_tcp+=" $URL доступен по tcp, получен статус код $tcp_status"
        echo "$log_tcp" >> access.log
    fi
    #echo "$status"
    sleep 10
done