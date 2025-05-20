sudo adduser user1
sudo usermod -aG sudo/wheel user1
sudo adduser user2
sudo adduser --shell /bin/sh user3
#passwdd username -чтобы сменить пароль
sudo passwd user1
sudo passwd user2
sudo passwd user3
-o PubkeyAuthentication=no
-o PasswordAuthentication=no
ssh-keygen -t rsa -b 4096 -C "aws" -f ~/.ssh/new_key
