#!/bin/bash

detect_os() {
    if [ -f /etc/redhat-release ]; then
        echo "redhat"
    elif [ -f /etc/lsb-release ] && grep -q "DISTRIB_ID=Ubuntu" /etc/lsb-release; then
        echo "ubuntu"
    else
        echo "unsupported"
        exit 1
    fi
}

install_aws_cli() {
    local os_type=$1
    if [ "$os_type" == "redhat" ]; then
        sudo yum update -y
        sudo yum install -y unzip
    elif [ "$os_type" == "ubuntu" ]; then
        sudo apt update
        sudo apt install -y unzip
    else
        echo "Неподдерживаемая ОС"
        exit 1
    fi
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && /
    unzip awscliv2.zip && /
    sudo ./aws/install && /
    rm -rf awscliv2.zip
    echo "AWS CLI успешно установлен"
    aws --version
}

setup_aws_profile() {
    aws_access_key_id=""
    aws_secret_access_key=""    
    aws_region="us-east-1"
    profile_name="default"
    CRED_FILE=~/.aws/credentials
    CONF_FILE=~/.aws/config
    mkdir -p ~/.aws
    touch $CRED_FILE
    echo "[${profile_name}]" >> $CRED_FILE
    echo "aws_access_key_id = ${aws_access_key_id}" >> $CRED_FILE
    echo "aws_secret_access_key = ${aws_secret_access_key}" >> $CRED_FILE
    touch $CONF_FILE
    echo "[${profile_name}]" >> $CONF_FILE
    echo "region = ${aws_region}" >> $CONF_FILE    
    echo "Настройка AWS CLI завершена. Профиль '${profile_name}' создан."
}

main() {
    echo "Определение ОС..."
    os_type=$(detect_os)
    echo "Обнаружена ОС: $os_type"
    install_aws_cli "$os_type"
    setup_aws_profile
}

main