#!/bin/bash

# Network
docker network create elk --attachable

# Volumes
docker volume create kibana
docker volume create logstash
docker volume create elasticsearch

#END