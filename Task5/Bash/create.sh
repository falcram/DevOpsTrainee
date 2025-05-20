mkdir /var/www/task3/cpu
cp ../var/www/task3/cpu/index.html /var/www/task3/cpu/
cp cpu_usage.sh /var/www/task3/cpu/
cp cpu_usage.txt /var/www/task3/cpu/
cp cpu_usage.service /etc/systemd/system
systemctl enable cpu_usage.service
systemctl start cpu_usage.service
setfacl -R -m u:nginx:rwx /var/www/task3/
