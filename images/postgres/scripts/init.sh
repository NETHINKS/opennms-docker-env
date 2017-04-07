#!/bin/bash 
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Postgresql Container                                                   #
# init.sh                                                                #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${POSTGRES_USER+x} ]; then POSTGRES_USER="postgres"; fi
if [ -z ${POSTGRES_PASSWORD+x} ]; then POSTGRES_PASSWORD="postgres"; fi

# create Postgres cluster
su postgres -c "PGDATA=/data/container/pgdata/ /usr/pgsql-9.5/bin/initdb"

# start Postgres in background and wait for startup
su postgres -c  "PGDATA=/data/container/pgdata/ /usr/pgsql-9.5/bin/pg_ctl -w start"

# create Postgres user
if [ "$POSTGRES_USER" = 'postgres' ]; then
    SQL="ALTER USER ${POSTGRES_USER} WITH SUPERUSER PASSWORD '${POSTGRES_PASSWORD}';"
else
    SQL="CREATE USER ${POSTGRES_USER} WITH SUPERUSER PASSWORD '${POSTGRES_PASSWORD}';"
fi
echo ${SQL} | /usr/pgsql-9.5/bin/psql -U postgres

# import sql dumps
/opt/containerscripts/import.sh

# stop the background  Postgres process
su postgres -c  "PGDATA=/data/container/pgdata/ /usr/pgsql-9.5/bin/pg_ctl -w stop"

# update postgresql.conf to listen on all interfaces
su postgres -c "sed -i 's/#listen_addresses.*/listen_addresses = '\"'\"'*'\"'\"'/g' /data/container/pgdata/postgresql.conf"

# update pg_hba.conf
su postgres -c "echo 'host all all all md5' >> /data/container/pgdata/pg_hba.conf"
