#!/bin/bash


# https://hub.docker.com/r/bitnami/wordpress

# Create a network
docker network create invozone

# Mysql Setup
docker run --name mysql --user=root -e MYSQL_DATABASE="iz_wp_website_v3" -e MYSQL_ROOT_USER="fwfnehip" -e MYSQL_ROOT_PASSWORD="ausdermito" -v /root/mysql:/bitnami/mysql/data --network="invozone" --restart unless-stopped -d bitnami/mysql:5.7.32

# Phpmyadmin Setup
#docker run --name phpmyadmin --network="invozone" --link mysql:db -id -p 8080:80 --restart unless-stopped phpmyadmin/phpmyadmin


# Wordpress Setup
docker run --name bitnami-wordpress -u root --network="invozone" -e WORDPRESS_DATABASE_NAME="iz_wp_website_v3" -e WORDPRESS_DATABASE_USER="fwfnehip" -e WORDPRESS_DATABASE_PASSWORD="ausdermito" -e MARIADB_HOST="mysql" -v /root/wordpress:/bitnami --restart unless-stopped -d bitnami/wordpress:latest


# Nginx Container

mkdir -p ~/ssl/certs

#2
mkdir -p ~/nginx/conf.d

#3
#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ~/ssl/certs/nginx-selfsigned.key -out ~/ssl/certs/nginx-selfsigned.crt
openssl req \
    -new \
    -newkey rsa:4096 \
    -days 3650 \
    -nodes \
    -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
    -keyout ~/ssl/certs/nginx-selfsigned.key \
    -out ~/ssl/certs/nginx-selfsigned.crt
#4
openssl dhparam -out ~/ssl/certs/dhparam.pem 2048

#5
cd ~/nginx/conf.d


#6
echo '
server {
  listen 80;
  server_name dev.invozone.com;
  return 301 $scheme://dev.invozone.com$request_uri;
}
server {
  server_name dev.invozone.com;
  listen 443 ssl;
  ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
  ssl_certificate_key /etc/ssl/certs/nginx-selfsigned.key;
  ssl_dhparam /etc/ssl/certs/dhparam.pem;
    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers    TLS-CHACHA20-POLY1305-SHA256:TLS-AES-256-GCM-SHA384:TLS-AES-128-GCM-SHA256:HIGH:!aNULL:!MD5;
location / {
    proxy_set_header        Host $host:$server_port;
    proxy_set_header        X-Real-IP $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
    proxy_redirect http:// https://;
    proxy_pass              http://bitnami-wordpress:8080;
    # Required for new HTTP-based CLI
    proxy_http_version 1.1;
    proxy_request_buffering off;
       }
}' >  ~/nginx/conf.d/server.conf

#7
docker run --name nginx --network=invozone --restart unless-stopped -v ~/ssl/certs:/etc/ssl/certs -v ~/nginx/conf.d:/etc/nginx/conf.d -p 443:443 -p 80:80 -d nginx


#END
