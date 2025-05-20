#!/bin/bash

WORK_URL=""

if [ "$1" = "" ]; then
    WORK_URL="https://task3.zapto.org/"
else
    WORK_URL=$1
fi

curl -s "$WORK_URL" | grep -P "<a[^>]*>[^<]+<\/a>" >> links.txt 