#!/bin/bash
# Purpose: ELK Stack in docker
# Maintainer: Muhammad Asim <cloudgeeks.ca>


# Docker Network
docker network create elk --attachable

# Docker Volumes
docker volume create kibana
docker volume create logstash
docker volume create elasticsearch

# docker-compose setup

mkdir $PWD/elk
cat > $PWD/elk/docker-compose.yaml <<'EOF'
version: '3.7'

services:
  elasticsearch:
    image: bitnami/elasticsearch:latest
    networks:
      - elk
    restart: unless-stopped
    container_name: elasticsearch
    ports:
      - '9200:9200'
    volumes:
      - elasticsearch:/bitnami/elasticsearch/data

  kibana:
    image: bitnami/kibana:latest
    networks:
      - elk
    restart: unless-stopped
    container_name: kibana
    ports:
      - '5601:5601'
    depends_on: 
      - elasticsearch
    environment:
        - KIBANA_ELASTICSEARCH_URL=elasticsearch
    volumes:
        - kibana:/bitnami

  logstash:
    image: bitnami/logstash:latest
    networks:
      - elk
    restart: unless-stopped
    container_name: logstash
    ports:
      - '8080:8080'
    volumes:
        - logstash:/bitnami


volumes:
  kibana:
  elasticsearch:
  logstash:
networks:
  elk:
   external: true
EOF

cd elk

docker-compose up -d


#END
