#!/bin/bash
# Purpose: efk Stack in docker
# Maintainer: Muhammad Asim <cloudgeeks.ca>
# Filebeat https://www.elastic.co/guide/en/beats/filebeat/current/running-on-docker.html



# NOTE: Always make a custom network for containers & run containers on that network, if containers are already running in custom network attach a custom network with it.

# Docker Network
docker network create efk --attachable

# Docker Volumes
docker volume create elasticsearch

# docker-compose setup

mkdir $PWD/efk
cat > $PWD/efk/docker-compose.yaml <<'EOF'
version: '3.7'

services:

  elasticsearch:
    image: elasticsearch:7.9.2
    container_name: elasticsearch
    networks:
      - efk
    environment:
      - node.name=elasticsearch
      - discovery.seed_hosts=elasticsearch
      - cluster.initial_master_nodes=elasticsearch
      - cluster.name=docker-cluster
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
      memlock:
        soft: -1
        hard: -1
    volumes:
      - elasticsearch:/usr/share/elasticsearch/data
    ports:
      - 9200:9200

  kibana:
    image: kibana:7.9.2
    networks:
      - efk
    container_name: kibana
    environment:
      ELASTICSEARCH_URL: "http://elasticsearch:9200"
    ports:
      - 5601:5601
    depends_on:
      - elasticsearch

volumes:
  elasticsearch:
networks:
  efk:
   external: true
EOF

cd efk

docker-compose up -d


# Filebeat Container
mkdir $PWD/filebeat

cd filebeat

cat > filebeat.docker.yml <<'EOF'
filebeat.config:
  modules:
    path: ${path.config}/modules.d/*.yml
    reload.enabled: false

filebeat.autodiscover:
  providers:
    - type: docker
      hints.enabled: true

processors:
- add_cloud_metadata: ~

output.elasticsearch:
  hosts: '${ELASTICSEARCH_HOSTS:elasticsearch:9200}'
EOF

docker run -d \
  --name=filebeat \
  --network=efk \
  --user=root \
  --volume="$(pwd)/filebeat.docker.yml:/usr/share/filebeat/filebeat.yml:ro" \
  --volume="/var/lib/docker/containers:/var/lib/docker/containers:ro" \
  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
  -v $(which docker):/usr/bin/docker \
  docker.elastic.co/beats/filebeat:7.11.1 filebeat -e -strict.perms=false \
  -E output.elasticsearch.hosts=["elasticsearch:9200"]

sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" >> /etc/sysctl.conf  


# Example nginx
# docker run --name nginx -p 8085:80 -id nginx:latest

# sysctl -w vm.max_map_count=262144
# echo "vm.max_map_count=262144" >> /etc/sysctl.conf
#END