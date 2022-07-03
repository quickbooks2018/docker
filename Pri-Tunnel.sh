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

cat <<EOF > docker-compose.yaml
services:
  mongo:
    image: mongo:latest
    container_name: pritunldb
    hostname: pritunldb
    network_mode: bridge
    volumes:
      - ./db:/data/db

  pritunl:
    image: goofball222/pritunl:latest
    container_name: pritunl
    hostname: pritunl
    depends_on:
        - mongo
    network_mode: bridge
    privileged: true
    sysctls:
      - net.ipv6.conf.all.disable_ipv6=0
    links:
      - mongo
    volumes:
      - /etc/localtime:/etc/localtime:ro
    ports:
      - 80:80
      - 443:443
      - 8090:1194/tcp
    environment:
      - TZ=UTC
EOF


# https://hub.docker.com/u/pritunl

# docker network create pritunl --attachable

# https://hub.docker.com/_/mongo

# docker run --name mongodb -e MONGO_INITDB_ROOT_USERNAME=mongoadmin -e MONGO_INITDB_ROOT_PASSWORD=secret -e MONGO_INITDB_DATABASE=pritunl --network pritunl -v mongodb:/data/db --restart unless-stopped -id mongo:latest

# mongo --username mongoadmin --password --authenticationDatabase admin --host localhost --port 27017

# docker run --name pritunl --privileged -e MONGO_URI="mongodb://mongoadmin:secret@mongodb:27017/admin" -v pritunl:/var/lib/pritunl -v pritunl-conf:/etc --network pritunl -p 12323:1194/udp -p 12323:1194/tcp -p 80:80/tcp -p 443:443/tcp --restart unless-stopped -id docker.io/pritunl/pritunl-zero:latest

https://docs.pritunl.com/docs/pritunl-zero-service

# docker exec -it pritunl sh -c "pritunl-zero default-password"



# Username & Password ---> Start
# Username: pritunl Password: pritunl

##############################
# Docker Compose Instaalation
##############################

# https://docs.docker.com/compose/cli-command/
# https://docs.docker.com/compose/profiles/
# https://github.com/EugenMayer/docker-image-atlassian-jira/blob/master/docker-compose.yml

#########################################################################################
# 1 Run the following command to download the current stable release of Docker Compose
#########################################################################################

 mkdir -p ~/.docker/cli-plugins/
 curl -SL https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
 
 ###############################################
 # 2 Apply executable permissions to the binary
 ###############################################
 
  chmod +x ~/.docker/cli-plugins/docker-compose
  
  ###############################################
  # 3 Apply executable permissions to the binary
  ###############################################
  
  docker compose version
  
  
  
  
  # Commands
  # Build a Specific Profile
 #  docker compose -p app up -d --build

###########################
# Docker Compose Version 1
###########################
# https://docs.docker.com/compose/install/

curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

#END
