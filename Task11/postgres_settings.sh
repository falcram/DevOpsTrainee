#!/bin/bash

KEY=$1
PRIVATE_IP=$2

mkdir -p rpms_postgresql
cd rpms_postgresql

dnf download postgresql17 && \
dnf download postgresql17-private-libs && \
scp -o StrictHostKeyChecking=no -i $KEY ./* ec2-user@$PRIVATE_IP:/home/ec2-user && \
ssh -o StrictHostKeyChecking=no -i $KEY ec2-user@$PRIVATE_IP 'echo 'timeout=10' | sudo tee -a /etc/dnf/dnf.conf > /dev/null; sudo dnf install -y *.rpm --disablerepo="*" --releasever=2023.0' 
