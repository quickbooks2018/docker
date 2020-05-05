#!/bin/bash
# Purpose: Vault Quick Setup
# Maintainer: DevOps Muhammad Asim
# OS Ubuntu/Amazon_Linux

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh      2>&1 > /dev/null
rm -rf get-docker.sh
yum install -y docker 2>&1 > /dev/null
systemctl start docker
systemctl enable docker

# Docker Compose Installation

curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version







mkdir -p "${PWD}"/vault/{config,file,logs}

touch    "${PWD}"/vault/docker-compose.yml

cat << EOF > "${PWD}"/vault/config/vault.json

{
  "backend": {
    "file": {
      "path": "/vault/file"
    }
  },
  "listener": {
    "tcp":{
      "address": "0.0.0.0:8200",
      "tls_disable": 1
    }
  },
  "ui": true
}

EOF

cat << EOF > "${PWD}"/vault/docker-compose.yml
version: '3.7'
services:
  vault:
    image: vault:latest
    container_name: vault
    ports:
      - "8200:8200"
    restart: unless-stopped
    volumes:
      -  ./logs:/vault/logs
      -  ./file:/vault/file
      -  ./config:/vault/config
    cap_add:
      - IPC_LOCK
    entrypoint: vault server -config=/vault/config/vault.json

EOF

cd "${PWD}"/vault

docker-compose up -d

