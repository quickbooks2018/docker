#!/bin/bash


apt update -y

apt install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

apt update -y

apt-cache policy docker-ce

apt install docker-ce

usermod -aG docker ubuntu

# usermod -aG docker username

systemctl restart docker

systemctl status docker

systemctl enable docker

# RUN Docker with out sudo

sudo setfacl -m user:$USER:rw /var/run/docker.sock

exit 0

#END




