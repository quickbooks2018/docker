#!/bin/bash
# OS: Ubuntu16/18-LTS
# Purpose:Automated deployment of Pritunl
# Maintainer: Muhammad Asim

apt update -y
apt install -y curl


mkdir docker
cd docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
systemctl start docker
systemctl enable docker
rm -rf get-docker.sh

docker volume create pritunl-conf
docker volume ls

docker run --name pritunl --privileged -v ~/pritunl/mondodb:/var/lib/mongodb -v ~/pritunl/pritunl:/var/lib/pritunl -v pritunl-conf:/etc -p 12323:1194/udp -p 12323:1194/tcp -p 80:80/tcp -p 443:443/tcp --restart unless-stopped -d jippi/pritunl

# https://github.com/myoung34/docker-pritunl

docker network create pritunl --attachable

# https://hub.docker.com/_/mongo

docker run --name mongodb -e MONGO_INITDB_ROOT_USERNAME=mongoadmin -e MONGO_INITDB_ROOT_PASSWORD=secret -e MONGO_INITDB_DATABASE=pritunl --network pritunl -v mongodb:/data/db --restart unless-stopped -id mongo:latest

# mongo --username mongoadmin --password --authenticationDatabase admin --host localhost --port 27017

docker run --name pritunl --privileged -e MONGO_URI="mongodb://mongoadmin:secret@mongodb:27017/admin" -v pritunl:/var/lib/pritunl -v pritunl-conf:/etc --network pritunl -p 12323:1194/udp -p 12323:1194/tcp -p 80:80/tcp -p 443:443/tcp --restart unless-stopped -id docker.io/pritunl/pritunl-zero:latest

# Username & Password ---> Start
# Username: pritunl Password: pritunl


#END
