#!/bin/bash
# Purpose: efk Stack in docker
# Maintainer: Muhammad Asim <cloudgeeks.ca>
# Filebeat https://www.elastic.co/guide/en/beats/filebeat/current/running-on-docker.html


# Update me

domain="elasticsearch.cloudgeeks.ca"
export domain

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

# Filebeat Container which will work as a agent

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
EOF

docker run -id \
  --name=filebeat \
  --user=root \
  --volume="$(pwd)/filebeat.docker.yml:/usr/share/filebeat/filebeat.yml:ro" \
  --volume="/var/lib/docker/containers:/var/lib/docker/containers:ro" \
  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
  -v $(which docker):/usr/bin/docker \
  docker.elastic.co/beats/filebeat:7.11.1 filebeat -e -strict.perms=false \
  -E output.elasticsearch.hosts=["$domain:9200"]


  # Example nginx
# docker run --name nginx -p 8085:80 -id nginx:latest

# END