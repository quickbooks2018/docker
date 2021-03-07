#!/bin/bash
# Purpose: docker logging via Cloud Watch Logging
# OS: AmazonLinux

# Docker Installation

yum install -y docker

systemctl start docker

systemctl enable docker


# Docker Compose Installation 

curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

docker-compose --version


# Docker Cloud Watch Driver 

# nginx

docker run --name nginx --log-driver="awslogs" --log-opt awslogs-region=us-east-1 --log-opt awslogs-group="myapp/dev" --log-opt awslogs-stream="myapp-log-stream" -p 80:80 --restart unless-stopped  -id nginx:latest


# Run Docker outside AWS & push logs to AWS.
# aws configure

# edit /lib/systemd/system/docker.service file.

# In [Service] section add:

# [Service]
# Environment=AWS_SHARED_CREDENTIALS_FILE=<path_to_aws_credentials_file>

# ________________________________________________________________
# Environment=AWS_SHARED_CREDENTIALS_FILE=/root/.aws/credentials
# systemctl daemon-reload
# systemctl restart docker
# _________________________________________________________________

#   docker run --log-driver=awslogs \
# --log-opt awslogs-region=us-east-1 \
# --log-opt awslogs-group=cloudgeeks \
# --log-opt awslogs-create-group=true \
# --name cloudgeeks -d busybox sh -c "while true; do $(echo date); sleep 1; done"










# END