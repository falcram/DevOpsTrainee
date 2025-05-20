#!/bin/bash

echo "==Определить ip сайта google.com и проверить его доступность=="
nslookup google.com
ping -c 5 google.com
echo "==============================================================================="

read -n 1 -s

echo "==Определить маршрут следования пакета от инстанса до google.com=="
traceroute google.com
echo "==============================================================================="

read -n 1 -s

netstat -tulpn

netstat -tupn | grep -E 'LISTEN|ESTABLISHED'

echo "==Приложение на 80 порту=="
lsof -i :80
netstat -tulpn | grep :80
echo "==============================================================================="

read -n 1 -s

echo "==IP=="
hostname -I
echo "==IP расширенный=="
ip address

echo "==Роуты=="
ip route

echo "==Hostname=="
hostname
echo "==Username=="
whoami
echo "==============================================================================="

read -n 1 -s

echo "==Правила iptables=="
iptables -L -v -n
echo "==Конец правил iptables=="

echo "==Add rool=="
sudo iptables -A INPUT -p icmp -j DROP

ping -c 5 localhost

echo "==Delete rool=="
sudo iptables -D INPUT -p icmp -j DROP

ping -c 5 localhost
echo "==============================================================================="

read -n 1 -s

echo "== На локалке сделать так, чтобы dns запись google.com вела на другой сайт =="

ping -c 3 google.com

echo "40.114.177.156 google.com www.google.com" | sudo tee -a  /etc/hosts

ping -c 3 google.com

sed -i '$d' /etc/hosts  

read -n 1 -s

echo "== Просмотреть список запущенных процессов, объяснить вывод команды ps auxft, объяснить какой процесс под PID 1.=="

ps auxft

read -n 1 -s

echo "==Показать дочерние процессы процесса PID 1=="
ps --ppid 1

read -n 1 -s

echo "==Что такое RSS, VSZ, NI, PRI, STAT=="

ps -eo pid,rss,vsz,ni,pri,stat,comm

read -n 1 -s

echo "==Какой процесс используется твоим терминалом =="

ps -p $$

read -n 1 -s

echo "==Определить процессы которые имеют открытые файлы в директории /var/log, объяснить вывод использованной команды=="

lsof +D /var/log

read -n 1 -s

echo "==- Показать сколько места занято на дисках, показать сколько места на диске занимает директория /var/log/. Аналогично показать сколько занято inodes на дисках и в директории /var/log/; ==" 

df -h

du -sh /var/log

df -i
echo "==Inodes in directory (/var/log)=="
find /var/log -type f | wc -l
find /var/log | wc -l
#man iptables