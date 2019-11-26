#!/bin/bash
#Purpose: pgbadger reporting
#Prerequisites: docker must be installed & running on host


# Log file name ---> /cartodb-storage/log/postgresql/postgresql-9.3-main.log


# To Setup a cron job & fresh reports,I am removing the exisitng setup of container pgbadger-report

docker rm -f pgbadger-report 2>&1 >/dev/null

rm -rf /root/pgbadger 2>&1 >/dev/null

POSTGRESQL_LOGS_DIR=/cartodb-storage/log/postgresql
IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

export POSTGRESQL_LOGS_DIR

docker run --entrypoint /bin/sh --name pgbadger -v $POSTGRESQL_LOGS_DIR:/data -id uphold/pgbadger

docker exec pgbadger pgbadger /data/postgresql-9.3-main.log -f stderr --jobs 4 --outdir /

mkdir /root/pgbadger

docker cp pgbadger:/out.html /root/pgbadger

mv /root/pgbadger/out.html /root/pgbadger/index.html

docker rm -f pgbadger

docker run --name pgbadger-report -v /root/pgbadger:/usr/local/apache2/htdocs -p 10000:80 -d httpd

echo ""

echo "ALHUMDULLIAH Latest pgbadger-report is available at "$IP":10000"

echo ""

# docker rm -f pgbadger-report

#END
