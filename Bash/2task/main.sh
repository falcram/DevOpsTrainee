#!/bin/bash

#Принимает путь к лог-файлу как аргумент (./log_analyzer.sh /var/log/nginx/access.log).

#Если файл не передан – читает стандартный ввод (cat /var/log/nginx/access.log | ./log_analyzer.sh).

#Анализирует логи и выводит:

#Топ-5 IP-адресов по количеству запросов.

#Топ-5 URL-путей (/index.html, /api/user и т. д.).

#Общее количество запросов.

#Количество уникальных пользователей (по IP).

#Распределение HTTP-статусов (200, 404, 500 и т. д.).

#Средний размер ответа (байты).

#Фильтрация по дате (если передан --since YYYY-MM-DD и/или --until YYYY-MM-DD).

#Поддержка JSON-вывода (если передан --json).


LOG_FILE=""

if [ "$1" = "" ]; then
    LOG_FILE=/var/log/nginx/access.log
else
    LOG_FILE=$1
fi

grep -E -o "(\b25[0-5]|\b2[0-4][0-9]|\b[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}" "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5

grep -P -o "(?<=GET |POST |PUL |DELETE |LOG )\/\S*(?= HTTP)" "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5


#cat "$LOG_FILE"

#echo "$LOG_FILE"
