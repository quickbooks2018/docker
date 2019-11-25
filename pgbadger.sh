#!/bin/bash
#Purpose: pgbadger reporting
#Prerequisites: docker must be installed & running on host


# Log file name ---> /cartodb-storage/log/postgresql/postgresql-9.3-main.log

POSTGRESQL_LOGS_DIR=/cartodb-storage/log/postgresql

export POSTGRESQL_LOGS_DIR

docker run --entrypoint /bin/sh --name pgbadger -v $POSTGRESQL_LOGS_DIR:/data -id uphold/pgbadger

docker exec pgbadger pgbadger /data/postgresql-9.3-main.log -f stderr --jobs 4 --outdir /

mkdir /root/pgbadger

docker cp pgbadger:/out.html /root/pgbadger

mv /root/pgbadger/out.html /root/pgbadger/index.html

docker rm -f pgbadger

docker run --name pgbadger-report -v /root/pgbadger:/usr/local/apache2/htdocs -p 10000:80 -d httpd

# docker rm -f pgbadger-report

#END