cp -r var/www/task3 /var/www/
setfacl -R -m u:nginx:rwx /var/www/task3
setfacl -R -m u:apache:rwx /var/www/task3

#mkdir /var/www/task3
#mkdir /var/www/task3/music
#mkdir /var/www/task3/secondpage
#mkdir /var/www/task3/red
#mkdir /var/www/task3/blue
#mkdir /var/www/task3/
#sudo apt update
#sudo apt install apache2 php libapache2-mod-php
#sudo dnf install httpd php php-cli php-common
#mkdir /var/www/task3/php
#touch /var/www/task3/php/info.php
#echo "<?php phpinfo(); ?>" | tee /var/www/task3/php/info.php
# в /etc/apache2/ports.conf сменить порт на 8080
# в /etc/apache2/sites-enabled/000-default.conf тоже сменить порт на 8080
# в etc/apache2/sites-available/000-default.conf
# DocumentRoot /var/www/task3/php
#
#    <Directory /var/www/task3/php>
#        Options Indexes FollowSymLinks
#        AllowOverride All
#        Require all granted
#    </Directory>
#sudo mkdir -p /etc/nginx/ssl
#sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#    -keyout /etc/nginx/ssl/nginx-selfsigned.key \
#    -out /etc/nginx/ssl/nginx-selfsigned.crt
#..+.+..............+.+........+.+.....+.+.....+...+..........+++++++++++++++++++++++++++++++++++++++*..+.........+...+......+.......+...+++++++++++++++++++++++++++++++++++++++*...+.+..+.......+..+......+....+...+..+.+...+........................+......+.....+.+...........+.......+...........+......+.+..+...+.......+..+.+........+.+...+..+....+.....+.......+.....+.......+...............+.....+......+.+.....+...............+.+.........+......+..+...+.......+...++++++
#........+........+.......+......+.....+...+......+.+..+............+.+...+.........+..+...+++++++++++++++++++++++++++++++++++++++*..+...+........+.+...........+...+.+.....+.+++++++++++++++++++++++++++++++++++++++*...+..+.+..+.......+.....+.......+......+.........+.....+.+..+...+....+...+..+.+...........................+...............+.....+...........................+.+..+.+..............+...+...+.+......+........+....+........+....+...+...........+.+...+.....+.......+..............+.+......+...+..............+................+..++++++
#-----
#You are about to be asked to enter information that will be incorporated
#into your certificate request.
#What you are about to enter is what is called a Distinguished Name or a DN.
#There are quite a few fields but you can leave some blank
#For some fields there will be a default value,
#If you enter '.', the field will be left blank.
#-----
#Country Name (2 letter code) [XX]:BY
#State or Province Name (full name) []:Minsk
#Locality Name (eg, city) [Default City]:Minsk
#organization Name (eg, company) [Default Company Ltd]:Task3
#organizational Unit Name (eg, section) []:Task3
#Common Name (eg, your name or your server's hostname) []:task3.zapto.org
#Email Address []:arsenydubovik@gmail.com


