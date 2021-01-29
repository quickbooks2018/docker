#!/bin/bash

# Custom Network Setup
docker network create postgres --attachable

# Postgres Setup
docker run --name postgres --network="postgres" -e POSTGRES_PASSWORD="12345678" -p 5432:5432 -id quickbooks2018/postgres

## Adminer Setup
#docker run --link postgres:db --network="postgres" -p 8080:8080 -id adminer

## Go Setup
docker run --name goapp --network="postgres" -v "$PWD"/goapp:/usr/src/goapp -w /usr/src/goapp -p 80:8080 -id golang:latest

### PGADMIN

docker run --name pgadmin -e PGADMIN_DEFAULT_EMAIL="quickbooks2018@gmail.com" -e PGADMIN_DEFAULT_PASSWORD="pakistan1982" --network="postgres" -p 8090:80 -id dpage/pgadmin4:latest

# Create a Connection
# connection-name anynameyouwant
#username postgres
#password 12345678
#dbname   postgres

#END