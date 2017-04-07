#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Postgresql Container                                                   #
# export.sh                                                              #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${POSTGRES_USER+x} ]; then POSTGRES_USER="postgres"; fi
if [ -z ${POSTGRES_PASSWORD+x} ]; then POSTGRES_PASSWORD="postgres"; fi

# create directory
DUMPDIR="/data/export/postgres"
rm -Rf ${DUMPDIR}/*
mkdir -p ${DUMPDIR}

# export configuration
mkdir -p ${DUMPDIR}/etc
cp -R /data/container/pgdata/postgresql.conf /data/container/pgdata/pg_hba.conf ${DUMPDIR}/etc/.

# export databases: one dump per database
mkdir -p ${DUMPDIR}/sql
DATABASES=`psql -U ${POSTGRES_USER} -q -t -c "SELECT datname from pg_database WHERE datname NOT IN ('postgres', 'template0', 'template1')"`
for db in $DATABASES
do
    pg_dump -U ${POSTGRES_USER} -C "${db}" > "${DUMPDIR}/sql/db_${db}.sql"
done
