#!/bin/bash
# Purpose: efk Stack in docker
# Maintainer: Muhammad Asim <cloudgeeks.ca>
# Filebeat https://www.elastic.co/guide/en/beats/filebeat/current/running-on-docker.html


# Docker Installation

yum update -y

yum install -y docker

systemctl start docker

systemctl enable docker

# Docker Compose Installation

curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

docker-compose --version

# Update me

hostedzoneid="Z03934572G71TQI3ISVJR"
domain="elasticsearch.cloudgeeks.ca"



# NOTE: Always make a custom network for containers & run containers on that network, if containers are already running in custom network attach a custom network with it.

# Docker Network
docker network create efk --attachable

# Docker Volumes
docker volume create elasticsearch

# docker-compose setup
mkdir efk


echo "
---
version: '3.7'

services:

  elasticsearch:
    image: elasticsearch:7.9.2
    hostname: $domain
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
   external: true" > $PWD/efk/docker-compose.yaml

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

sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" >> /etc/sysctl.conf  


# Rout53 Section Private Hosted Zone

# Update route53 record
localip=$(curl -fs http://169.254.169.254/latest/meta-data/local-ipv4)

file=/tmp/record.json
cat << EOF > $file
{
  "Comment": "Update the A record set",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$domain",
        "Type": "A",
        "TTL": 30,
        "ResourceRecords": [
          {
            "Value": "$localip"
          }
        ]
      }
    }
  ]
}
EOF

aws route53 change-resource-record-sets --hosted-zone-id $hostedzoneid --change-batch file://$file