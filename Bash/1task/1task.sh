#!/bin/bash
#Задача: Написать скрипт, который обрабатывает конфигурационный файл nginx.conf и:

#Комментирует все строки с listen 80; (заменяет на # listen 80;).

#Удаляет все пустые строки.

#Заменяет server_name example.com; на server_name mydomain.com;.

INPUT_FILE=$1
OUTPUT_FILE="output.conf"


sed -E -e 's/listen[ ]+80/# listen 80/g' -e '/^[ ]*$/d' -e 's/(server_name[[:space:]]+[^;]+) (example\.com)/\1 mydomain\.com/g' "$INPUT_FILE" > "$OUTPUT_FILE" 