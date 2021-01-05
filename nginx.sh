#!/bin/bash

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

systemctl start docker

systemctl enable docker

docker network ls

docker network create --driver=bridge cloudgeeks-ca


#1 
mkdir -p ~/ssl/certs

#2 
mkdir -p ~/nginx/conf.d

#3 
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ~/ssl/certs/nginx-selfsigned.key -out ~/ssl/certs/nginx-selfsigned.crt

#4 
openssl dhparam -out ~/ssl/certs/dhparam.pem 2048

#5 
cd ~/nginx/conf.d

#6 
apt update -y  2> /dev/null 
apt install -y vim 2> /dev/null
yum update -y  2> /dev/null 
yum install -y vim 2> /dev/null

#7
echo '
server {
  listen 80;
  server_name teleport.cloudgeeks.ca;
  return 301 https://$host$request_uri;
}
server {
  server_name teleport.cloudgeeks.ca;
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
    proxy_pass              http://IP:8080;
    # Required for new HTTP-based CLI
    proxy_http_version 1.1;
    proxy_request_buffering off;
  
       }
}' >  ~/nginx/conf.d/server.conf

#8
docker run --name nginx --network=cloudgeeks-ca --restart unless-stopped -v ~/ssl/certs:/etc/ssl/certs -v ~/nginx/conf.d:/etc/nginx/conf.d -p 443:443 -p 80:80 -d nginx




#END
