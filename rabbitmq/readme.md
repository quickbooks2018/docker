# RabbitMQ Bitnami

# RabbitMQ Bitnami Setup

docker network create rabbitmq --attachable

docker run --name rabbitmq --user root --network rabbitmq -p 80:15672 -v $PWD/rabbitmq:/bitnami -id bitnami/rabbitmq:latest

# management console

user: user
password: bitnami

# Producer application
-----------------------
docker run --name producer -it --rm --network rabbitmq  -e RABBIT_HOST=rabbitmq -e RABBIT_PORT=5672 -e RABBIT_USERNAME=user -e RABBIT_PASSWORD=bitnami -p 8080:80 quickbooks2018/rabbitmq-producer:latest

curl -X POST http://localhost:8080/publish/cloudgeeks.ca

curl -X POST http://localhost:8080/publish/asim

curl -X POST http://ip172-18-0-25-c0mau2c34gag00fkhqv0-8080.direct.labs.play-with-docker.com/publish/asim


# Consumer application
-----------------------
docker run --name consumer -it --rm --network rabbitmq  -e RABBIT_HOST=rabbitmq -e RABBIT_PORT=5672 -e RABBIT_USERNAME=user -e RABBIT_PASSWORD=bitnami quickbooks2018/rabbitmq-consumer:latest




# Rabbit Mq Commands
---------------------
15672 ---> default management port Rabbitmq Management Plugin

docker exec -it root_rabbitmq_1 bash

rabbitmqctl


rabbitmq-plugins

rabbitmq-plugins list














# RabbitMQ

Docker image dockerhub (https://hub.docker.com/_/rabbitmq)
```
# run a standalone instance
docker network create rabbits
docker run -d --rm --net rabbits --hostname rabbit-1 --name rabbit-1 rabbitmq:3.8 

# how to grab existing erlang cookie
docker exec -it rabbit-1 cat /var/lib/rabbitmq/.erlang.cookie

# clean up
docker rm -f rabbit-1
```

# Management

```
docker run -d --rm --net rabbits -p 8080:15672 -e RABBITMQ_ERLANG_COOKIE=DSHEVCXBBETJJVJWTOWT --hostname rabbit-manager --name rabbit-manager rabbitmq:3.8-management

#join the manager

docker exec -it rabbit-manager rabbitmqctl stop_app
docker exec -it rabbit-manager rabbitmqctl reset
docker exec -it rabbit-manager rabbitmqctl join_cluster rabbit@rabbit-1
docker exec -it rabbit-manager rabbitmqctl start_app
docker exec -it rabbit-manager rabbitmqctl cluster_status
```

# Enable Statistics

docker exec -it rabbit-1 rabbitmq-plugins enable rabbitmq_management

docker exec -it rabbit-2 rabbitmq-plugins enable rabbitmq_management

docker exec -it rabbit-3 rabbitmq-plugins enable rabbitmq_management

# Message Publisher

```

cd messaging\rabbitmq\applications\publisher

docker build . -t aimvector/rabbitmq-publisher:v1.0.0

docker run -it --rm --net rabbits -e RABBIT_HOST=rabbit-1 -e RABBIT_PORT=5672 -e RABBIT_USERNAME=guest -e RABBIT_PASSWORD=guest -p 80:80 aimvector/rabbitmq-publisher:v1.0.0
```

# Message Consumer

```

docker build . -t aimvector/rabbitmq-consumer:v1.0.0

docker run -it --rm --net rabbits -e RABBIT_HOST=rabbit-1 -e RABBIT_PORT=5672 -e RABBIT_USERNAME=guest -e RABBIT_PASSWORD=guest aimvector/rabbitmq-consumer:v1.0.0
```

# Clustering 

https://www.rabbitmq.com/cluster-formation.html

## Note

Remember we will need the Erlang Cookie to allow instances to authenticate with each other.

# Manual Clustering 

```

docker exec -it rabbit-1 rabbitmqctl cluster_status

#join node 2

docker exec -it rabbit-2 rabbitmqctl stop_app

docker exec -it rabbit-2 rabbitmqctl reset

docker exec -it rabbit-2 rabbitmqctl join_cluster rabbit@rabbit-1

docker exec -it rabbit-2 rabbitmqctl start_app

docker exec -it rabbit-2 rabbitmqctl cluster_status

#join node 3
docker exec -it rabbit-3 rabbitmqctl stop_app

docker exec -it rabbit-3 rabbitmqctl reset

docker exec -it rabbit-3 rabbitmqctl join_cluster rabbit@rabbit-1

docker exec -it rabbit-3 rabbitmqctl start_app

docker exec -it rabbit-3 rabbitmqctl cluster_status

```

# Automated Clustering
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
#!/bin/bash

#Purpose: RabbitMQ Cluster

#Download Custom Configurations

curl -# -LO https://github.com/quickbooks2018/docker/raw/master/rabbitmq/rabbitmq.zip

unzip rabbitmq.zip

rm -f rabbitmq.zip

cp -r rabbitmq/config .

chown -R 1000:1000 config

docker network create rabbits --attachable

#1

docker run --name rabbit-1 --network rabbits -v ${PWD}/config/rabbit-1/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=CLOUDGEEKSCA -e RABBITMQ_DEFAULT_USER=asim -e RABBITMQ_DEFAULT_PASS=asim --hostname rabbit-1 -p 8081:15672 --restart unless-stopped -id rabbitmq:management

#2

docker run --name rabbit-2 --network rabbits -v ${PWD}/config/rabbit-2/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=CLOUDGEEKSCA -e RABBITMQ_DEFAULT_USER=asim -e RABBITMQ_DEFAULT_PASS=asim --hostname rabbit-2 -p 8082:15672 --restart unless-stopped -id rabbitmq:management

#3

docker run --name rabbit-3 --network rabbits -v ${PWD}/config/rabbit-3/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=CLOUDGEEKSCA -e RABBITMQ_DEFAULT_USER=asim -e RABBITMQ_DEFAULT_PASS=asim --hostname rabbit-3 -p 8083:15672 --restart unless-stopped -id rabbitmq:management

#enable federation plugin

sleep 20

docker exec -it rabbit-1 rabbitmq-plugins enable rabbitmq_federation

sleep 20

docker exec -it rabbit-2 rabbitmq-plugins enable rabbitmq_federation

sleep 20

docker exec -it rabbit-3 rabbitmq-plugins enable rabbitmq_federation


#mirror policy

sleep 30

docker exec -it rabbit-1 rabbitmqctl set_policy ha-fed ".*" '{"federation-upstream-set":"all", "ha-sync-mode":"automatic","ha-mode":"nodes", "ha-params":["rabbit@rabbit-1","rabbit@rabbit-2","rabbit@rabbit-3"]}' --priority 1 --apply-to queues

sleep 30

docker exec -it rabbit-2 rabbitmqctl set_policy ha-fed ".*" '{"federation-upstream-set":"all", "ha-sync-mode":"automatic","ha-mode":"nodes", "ha-params":["rabbit@rabbit-1","rabbit@rabbit-2","rabbit@rabbit-3"]}' --priority 1 --apply-to queues

sleep 30

docker exec -it rabbit-3 rabbitmqctl set_policy ha-fed ".*" '{"federation-upstream-set":"all", "ha-sync-mode":"automatic","ha-mode":"nodes", "ha-params":["rabbit@rabbit-1","rabbit@rabbit-2","rabbit@rabbit-3"]}' --priority 1 --apply-to queues

#Producer application

#docker run --name producer -it --rm --network rabbits -e RABBIT_HOST=rabbit-1 -e RABBIT_PORT=5672 -e RABBIT_USERNAME=asim -e RABBIT_PASSWORD=asim -p 8080:80 quickbooks2018/rabbitmq-producer:latest

#curl -X POST http://localhost:8080/publish/cloudgeeks.ca

#curl -X POST http://localhost:8080/publish/asim

#Consumer application

#docker run --name consumer -it --rm --network rabbits -e RABBIT_HOST=rabbit-1 -e RABBIT_PORT=5672 -e RABBIT_USERNAME=asim -e RABBIT_PASSWORD=asim quickbooks2018/rabbitmq-consumer:latest

#END

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------







#!/bin/bash

#Purpose: RabbitMQ Cluster


#Download Custom Configurations

curl -# -LO https://github.com/quickbooks2018/docker/raw/master/rabbitmq/rabbitmq.zip

unzip rabbitmq.zip

rm -f rabbitmq.zip

cp -r rabbitmq/config .

chown -R 1000:1000 config

docker network create rabbits --attachable

#1

docker run --name rabbit-1 --network rabbits -v ${PWD}/config/rabbit-1/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=CLOUDGEEKSCA -e RABBITMQ_DEFAULT_USER=asim -e RABBITMQ_DEFAULT_PASS=asim --hostname rabbit-1 -p 8081:15672 --restart unless-stopped -id rabbitmq:3.8-management

#2

docker run --name rabbit-2 --network rabbits -v ${PWD}/config/rabbit-2/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=CLOUDGEEKSCA -e RABBITMQ_DEFAULT_USER=asim -e RABBITMQ_DEFAULT_PASS=asim --hostname rabbit-2 -p 8082:15672 --restart unless-stopped -id rabbitmq:3.8-management

#3

docker run --name rabbit-3 --network rabbits -v ${PWD}/config/rabbit-3/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=CLOUDGEEKSCA -e RABBITMQ_DEFAULT_USER=asim -e RABBITMQ_DEFAULT_PASS=asim --hostname rabbit-3 -p 8083:15672 --restart unless-stopped -id rabbitmq:3.8-management

#enable federation plugin

sleep 10

docker exec -it rabbit-1 rabbitmq-plugins enable rabbitmq_federation 

sleep 10

docker exec -it rabbit-2 rabbitmq-plugins enable rabbitmq_federation

sleep 10

docker exec -it rabbit-3 rabbitmq-plugins enable rabbitmq_federation


#mirror policy

docker exec -it rabbit-1 rabbitmqctl set_policy ha-fed ".*" '{"federation-upstream-set":"all", "ha-sync-mode":"automatic","ha-mode":"nodes", "ha-params":["rabbit@rabbit-1","rabbit@rabbit-2","rabbit@rabbit-3"]}' --priority 1 --apply-to queues


docker exec -it rabbit-2 rabbitmqctl set_policy ha-fed ".*" '{"federation-upstream-set":"all", "ha-sync-mode":"automatic","ha-mode":"nodes", "ha-params":["rabbit@rabbit-1","rabbit@rabbit-2","rabbit@rabbit-3"]}' --priority 1 --apply-to queues


docker exec -it rabbit-3 rabbitmqctl set_policy ha-fed ".*" '{"federation-upstream-set":"all", "ha-sync-mode":"automatic","ha-mode":"nodes", "ha-params":["rabbit@rabbit-1","rabbit@rabbit-2","rabbit@rabbit-3"]}' --priority 1 --apply-to queues



#Producer application

#docker run --name producer -it --rm --network rabbits -e RABBIT_HOST=rabbit-1 -e RABBIT_PORT=5672 -e RABBIT_USERNAME=asim -e RABBIT_PASSWORD=asim -p 8080:80 quickbooks2018/rabbitmq-producer:latest


#curl -X POST http://localhost:8080/publish/cloudgeeks.ca

#curl -X POST http://localhost:8080/publish/asim


# AWS EC2
#Producer application

#docker run --name producer -it --rm --network host -e RABBIT_HOST=rabbit@"$HOSTNAME" -e RABBIT_PORT=15672 -e RABBIT_USERNAME=asim -e RABBIT_PASSWORD=asim -p 80:80 quickbooks2018/rabbitmq-producer:latest

#curl -X POST http://localhost:80/publish/cloudgeeks.ca

#Consumer application

#docker run --name consumer -it --rm --network rabbits  -e RABBIT_HOST=rabbit@"$HOSTNAME" -e RABBIT_PORT=5672 -e RABBIT_USERNAME=asim -e RABBIT_PASSWORD=asim quickbooks2018/rabbitmq-consumer:latest



#END






















# Linux

# 1
-----------------------------------------------------------------------------------------
# Download
curl -# -LO https://github.com/quickbooks2018/docker/raw/master/rabbitmq/rabbitmq.zip

docker network create rabbits --attachable

docker run --name rabbit-1 --network rabbits -v ${PWD}/config/rabbit-1/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=CLOUDGEEKSCA -e RABBITMQ_DEFAULT_USER=asim -e RABBITMQ_DEFAULT_PASS=asim --hostname rabbit-1 -p 8081:15672 --restart unless-stopped -id rabbitmq:3.8-management


```
docker run -d --rm --net rabbits `
-v ${PWD}/config/rabbit-1/:/config/ `
-e RABBITMQ_CONFIG_FILE=/config/rabbitmq `
-e RABBITMQ_ERLANG_COOKIE=CLOUDGEEKSCA `
--hostname rabbit-1 `
--name rabbit-1 `
-p 8081:15672 `
rabbitmq:3.8-management


# 2
-----------------------------------------------------------------------------------------

docker run --name rabbit-2 --network rabbits -v ${PWD}/config/rabbit-2/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=CLOUDGEEKSCA -e RABBITMQ_DEFAULT_USER=asim -e RABBITMQ_DEFAULT_PASS=asim --hostname rabbit-2 -p 8082:15672 --restart unless-stopped -id rabbitmq:3.8-management

docker run -d --rm --net rabbits `
-v ${PWD}/config/rabbit-2/:/config/ `
-e RABBITMQ_CONFIG_FILE=/config/rabbitmq `
-e RABBITMQ_ERLANG_COOKIE=CLOUDGEEKSCA `
--hostname rabbit-2 `
--name rabbit-2 `
-p 8082:15672 `
rabbitmq:3.8-management


# 3
-----------------------------------------------------------------------------------------

docker run --name rabbit-3 --network rabbits -v ${PWD}/config/rabbit-3/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=CLOUDGEEKSCA -e RABBITMQ_DEFAULT_USER=asim -e RABBITMQ_DEFAULT_PASS=asim --hostname rabbit-3 -p 8083:15672 --restart unless-stopped -id rabbitmq:3.8-management


docker run -d --rm --net rabbits `
-v ${PWD}/config/rabbit-3/:/config/ `
-e RABBITMQ_CONFIG_FILE=/config/rabbitmq `
-e RABBITMQ_ERLANG_COOKIE=CLOUDGEEKSCA `
--hostname rabbit-3 `
--name rabbit-3 `
-p 8083:15672 `
rabbitmq:3.8-management

#NODE 1 : MANAGEMENT http://localhost:8081
#NODE 2 : MANAGEMENT http://localhost:8082
#NODE 3 : MANAGEMENT http://localhost:8083

# enable federation plugin
docker exec -it rabbit-1 rabbitmq-plugins enable rabbitmq_federation 
docker exec -it rabbit-2 rabbitmq-plugins enable rabbitmq_federation
docker exec -it rabbit-3 rabbitmq-plugins enable rabbitmq_federation

```

# Basic Queue Mirroring 

```
docker exec -it rabbit-1 bash

# https://www.rabbitmq.com/ha.html#mirroring-arguments

rabbitmqctl set_policy ha-fed \
    ".*" '{"federation-upstream-set":"all", "ha-mode":"nodes", "ha-params":["rabbit@rabbit-1","rabbit@rabbit-2","rabbit@rabbit-3"]}' \
    --priority 1 \
    --apply-to queues
```

# Automatic Synchronization

https://www.rabbitmq.com/ha.html#unsynchronised-mirrors

```
rabbitmqctl set_policy ha-fed \
    ".*" '{"federation-upstream-set":"all", "ha-sync-mode":"automatic", "ha-mode":"nodes", "ha-params":["rabbit@rabbit-1","rabbit@rabbit-2","rabbit@rabbit-3"]}' \
    --priority 1 \
    --apply-to queues
```

# Further Reading

https://www.rabbitmq.com/ha.html


# Clean up

```
docker rm -f rabbit-1
docker rm -f rabbit-2
docker rm -f rabbit-3
```

