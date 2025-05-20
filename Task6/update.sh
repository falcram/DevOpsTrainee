#!/bin/bash

PUB_KEY="/home/fulcrum/Downloads/Trainee_key.pem"
USER="ec2-user"
HOSTNAME="3.236.168.200"

CMD="sudo dnf update"

echo "Обновление происходит на $USER:$HOSTNAME"

ssh -i "$PUB_KEY" "$USER@$HOSTNAME" "$CMD"

if [ $? -eq 0 ]; then
    echo "Обновление пакетов успешно выполнено."
else
    echo "Ошибка при выполнении обновления пакетов." >&2
    exit 1
fi