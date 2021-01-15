#!/bin/bash
# https://stackoverflow.com/questions/36923214/docker-nginx-connection-refused-while-connecting-to-upstream

#1
mkdir -p ~/nginx/conf.d

#2
cd ~/nginx/conf.d


#3
echo '
upstream all {
server asim_cloudgeeksapp_1:4001;
server asim_cloudgeeksapp_2:4001;
server asim_cloudgeeksapp_3:4001;
server asim_cloudgeeksapp_4:4001;
server asim_cloudgeeksapp_5:4001;
server asim_cloudgeeksapp_6:4001;
    }

server {
  listen 80;
  server_name http://docker.cloudgeeks.io/;
  return 301 https://$host$request_uri;
}
server {
  server_name http://docker.cloudgeeks.io/;
  listen 443 ssl;
  ssl_certificate /etc/ssl/certs/fullchain1.pem;
  ssl_certificate_key /etc/ssl/certs/privkey1.pem;


    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers    TLS-CHACHA20-POLY1305-SHA256:TLS-AES-256-GCM-SHA384:TLS-AES-128-GCM-SHA256:HIGH:!aNULL:!MD5;



location / {
    proxy_set_header        Host $host:$server_port;
    proxy_set_header        X-Real-IP $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
    proxy_redirect http:// https://;
    proxy_pass              http://cloudgeeksapp:4001;
    # Required for new HTTP-based CLI
    proxy_http_version 1.1;
    proxy_request_buffering off;

       }
}' >  ~/nginx/conf.d/server.conf


#4
docker run --name nginx --network cloudgeeks --restart unless-stopped -v /etc/letsencrypt/archive/docker.cloudgeeks.io:/etc/ssl/certs -v ~/nginx/conf.d:/etc/nginx/conf.d -p 443:443 -p 80:80 -d nginx