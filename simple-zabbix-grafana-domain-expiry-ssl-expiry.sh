#!/bin/bash
# Purpose: Monitoring
# OS AmazonLinux
# Maintainer DevOps Muhammad Asim <quickbooks2018@gmail.com>

# Docker Installation
yum install -y docker 2>&1 > /dev/null
systemctl start docker
systemctl enable docker

# Docker Compose Installation

curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

# Zabbix Default Password
#Admin
#zabbix


# Docker Network
docker network create zabbix --attachable

# Start empty MySQL server instance
docker volume create zabbix-mysql
docker volume create zabbix-mysql-conf
docker run --name mysql-server -t  --restart unless-stopped \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="123456789" \
      -v zabbix-mysql:/var/lib/mysql \
      -v zabbix-mysql-conf:/etc/mysql/conf.d \
      --network "zabbix" \
      -e MYSQL_ROOT_PASSWORD="root_pwd" \
      -id mysql:latest \
      --character-set-server=utf8 --collation-server=utf8_bin \
      --default-authentication-plugin=mysql_native_password



sleep 10
# Start Zabbix server instance and link the instance with created MySQL server instance
docker volume create zabbix-conf
docker run --name zabbix-server -t \
      -e DB_SERVER_HOST="mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="123456789" \
      -e MYSQL_ROOT_PASSWORD="root_pwd" \
      -v zabbix-conf:/etc/zabbix \
      -h zabbix-server \
      --network "zabbix" \
      --link mysql-server:mysql \
      -p 10051:10051 \
      --restart unless-stopped \
      -d zabbix/zabbix-server-mysql:latest



sleep 10
# Start Zabbix web interface and link the instance with created MySQL server and Zabbix server instances
docker run --name zabbix-web-nginx-mysql -t \
      -e DB_SERVER_HOST="mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="123456789" \
      -e MYSQL_ROOT_PASSWORD="root_pwd" \
      --network "zabbix" \
      --link mysql-server:mysql \
      --link zabbix-server:zabbix-server \
      -p 80:8080 \
      --restart unless-stopped \
      -d zabbix/zabbix-web-nginx-mysql:latest

sleep 10
# Zabbix-Agent
docker run --name zabbix-agent --network="zabbix" --restart unless-stopped -id zabbix/zabbix-agent:latest


docker volume create grafana-etc
docker volume create grafana
docker run -id --name=grafana --network zabbix -v  grafana:/var/lib/grafana -v grafana-etc:/etc/grafana -p 3000:3000 grafana/grafana:latest
docker exec grafana grafana-cli plugins install alexanderzobnin-zabbix-app
docker restart grafana

# Configurations

docker exec -u root -it zabbix-agent apk add openssl

# Domain SSL Expiry

echo 'data=`echo | openssl s_client -servername $1 -connect $1:${2:-443} 2>/dev/null | openssl x509 -noout -enddate | sed -e 's#notAfter=##'`

ssldate=`date -d "${data}" '+%s'`

nowdate=`date '+%s'`

diff="$((${ssldate}-${nowdate}))"

echo $((${diff}/86400))' > domain_ssl_expiry.sh


chmod +x domain_ssl_expiry.sh 
docker cp domain_ssl_expiry.sh zabbix-agent:/var/lib/zabbix/domain_ssl_expiry.sh

# Domain Expiry
docker run --name tmp-container -id quickbooks2018/zabbix-agent
docker cp tmp-container:/var/lib/zabbix/checkdomain.sh .
chmod +x checkdomain.sh
mv checkdomain.sh domain_expiry.sh
docker rm -f tmp-container
docker cp domain_expiry.sh zabbix-agent:/var/lib/zabbix/domain_expiry.sh


#END

# Addtional Notes
# Zabbix API
# http://privateip/api_jsonrpc.php      # Eg: http://10.20.1.20/api_jsonrpc.php
# http://127.0.0.1/zabbix/api_jsonrpc.php # Eg: http://172.31.10.4/zabbix/api_jsonrpc.php

# http://172.31.15.234/zabbix/api_jsonrpc.php
# http://zabbix-web-nginx-mysql:8080/api_jsonrpc.php

# Docker remove all containers
# docker rm -f $(docker ps -aq)