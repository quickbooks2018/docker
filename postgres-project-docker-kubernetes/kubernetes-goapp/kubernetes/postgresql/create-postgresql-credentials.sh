#!/bin/bash
#Maintainer: Muhammad Asim <quickbooks2018@gmail.com>
# OS: AmazonLinux
# Note: Scripts are created in Windows environment, to run these in Linux/Unix based OS ---> use dos2unix


if [ ! -f ./POSTGRES_env ]; then
  echo "Could not find ENV variables file for POSTGRES - ./kubernetes/database/POSTGRES_env"
  exit 1
fi

echo "First delete the old secret: POSTGRES-credentials"
kubectl delete secret postgres-credentials  || true

echo "Found POSTGRES_env file, creating kubernetes secret: POSTGRES-credentials"
source ./POSTGRES_env


kubectl create secret generic postgres-credentials \
  --from-literal=POSTGRES_DB=${POSTGRES_DATABASE} \
  --from-literal=POSTGRES_USER=${POSTGRES_USER} \
  --from-literal=POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
