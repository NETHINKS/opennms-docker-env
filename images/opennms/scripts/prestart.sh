#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# OpenNMS Container                                                      #
# prestart.sh                                                            #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${INIT_DB_SERVER+x} ]; then DB_SERVER=dbserver; fi
if [ -z ${INIT_DB_USER+x} ]; then DB_USER=postgres; fi
if [ -z ${INIT_DB_PASSWORD+x} ]; then DB_PASSWORD=secret; fi
if [ -z ${INIT_CASSANDRA_ENABLE+x} ]; then INIT_CASSANDRA_ENABLE=false; fi
if [ -z ${INIT_CASSANDRA_SERVER+x} ]; then INIT_CASSANDRA_SERVER=cassandra; fi
if [ -z ${INIT_CASSANDRA_USER+x} ]; then INIT_CASSANDRA_USER=cassandra; fi
if [ -z ${INIT_CASSANDRA_PASSWORD+x} ]; then INIT_CASSANDRA_PASSWORD=secret; fi
if [ -z ${INIT_ADMIN_USER+x} ]; then INIT_ADMIN_USER=admin; fi
if [ -z ${INIT_ADMIN_PASSWORD+x} ]; then INIT_ADMIN_PASSWORD=admin; fi
if [ -z ${INIT_API_USER+x} ]; then INIT_API_USER=api; fi
if [ -z ${INIT_API_PASSWORD+x} ]; then INIT_API_PASSWORD=api; fi

# remove old directories and symlinks
rm -Rf /opt/opennms/lib/*
rm -Rf /opt/opennms/jetty-webapps/*

# init OpenNMS lib directory
cp -R /data/ref/lib/* /opt/opennms/lib
FILECOUNT_LIB_ADD=`ls -1 /data/container/lib_add | wc -l`
if [ $FILECOUNT_LIB_ADD -gt 0 ]
    then
        cp -R /data/container/lib_add/* /opt/opennms/lib
fi

# init OpenNMS web directory
cp -R /data/ref/jetty-webapps/* /opt/opennms/jetty-webapps
FILECOUNT_WEB_ADD=`ls -1 /data/container/web_add | wc -l`
if [ $FILECOUNT_WEB_ADD -gt 0 ]
    then
        cp -R /data/container/web_add/* /opt/opennms/jetty-webapps
fi

# waiting for Postgres startup
while true
do
    PGPASSWORD=$INIT_DB_PASSWORD psql -h $INIT_DB_SERVER -U $INIT_DB_USER -c "\l"
    if [ $? -eq 0 ]
    then
        echo "Connection to PostgreSQL server successful"
        break
    fi
    echo "Could not connect to PostgreSQL server, waiting 10 sec and trying again..."
    sleep 10
done

# waiting for Cassandra startup if newts is enabled
if [[ ${INIT_CASSANDRA_ENABLE} == "true" ]]; then
    while true
    do
        /opt/cassandra/bin/cqlsh -u $INIT_CASSANDRA_USER -p $INIT_CASSANDRA_PASSWORD $INIT_CASSANDRA_SERVER -e "DESC KEYSPACES"
        if [ $? -eq 0 ]
        then
            echo "Connection to Cassandra server successful"
            break
        fi
        echo "Could not connect to Cassandra server, waiting 10 sec and trying again..."
        sleep 10
    done
fi
