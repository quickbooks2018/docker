#https://hub.docker.com/_/rabbitmq
#https://www.rabbitmq.com/cluster-formation.html#peer-discovery-aws
#https://github.com/docker-library/rabbitmq/issues/61

FROM rabbitmq:3.6.9-management

RUN rabbitmq-plugins enable --offline rabbitmq_peer_discovery_aws rabbitmq_federation rabbitmq_prometheus

RUN chmod 666 /etc/rabbitmq/*
