#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# OpenNMS Container                                                      #
# init.sh                                                                #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${INIT_DB_SERVER+x} ]; then INIT_DB_SERVER=dbserver; fi
if [ -z ${INIT_DB_USER+x} ]; then INIT_DB_USER=postgres; fi
if [ -z ${INIT_DB_PASSWORD+x} ]; then INIT_DB_PASSWORD=secret; fi
if [ -z ${INIT_CASSANDRA_ENABLE+x} ]; then INIT_CASSANDRA_ENABLE=false; fi
if [ -z ${INIT_CASSANDRA_SERVER+x} ]; then INIT_CASSANDRA_SERVER=cassandra; fi
if [ -z ${INIT_CASSANDRA_USER+x} ]; then INIT_CASSANDRA_USER=cassandra; fi
if [ -z ${INIT_CASSANDRA_PASSWORD+x} ]; then INIT_CASSANDRA_PASSWORD=secret; fi
if [ -z ${INIT_ADMIN_USER+x} ]; then INIT_ADMIN_USER=admin; fi
if [ -z ${INIT_ADMIN_PASSWORD+x} ]; then INIT_ADMIN_PASSWORD=admin; fi
if [ -z ${INIT_API_USER+x} ]; then INIT_API_USER=api; fi
if [ -z ${INIT_API_PASSWORD+x} ]; then INIT_API_PASSWORD=api; fi

# init configuration
/opt/containerscripts/opennms/create_conf_datasources.py \
    ${INIT_DB_SERVER} ${INIT_DB_USER} ${INIT_DB_PASSWORD} \
    > /data/container/etc/opennms-datasources.xml

/opt/containerscripts/opennms/create_conf_users.py \
    ${INIT_ADMIN_USER}:${INIT_ADMIN_PASSWORD}:ROLE_ADMIN \
    ${INIT_API_USER}:${INIT_API_PASSWORD}:ROLE_USER \
    > /data/container/etc/users.xml

/opt/containerscripts/opennms/create_conf_webbase.py \
    > /data/container/etc/opennms.properties.d/web-base.properties

if [[ ${INIT_CASSANDRA_ENABLE} == "true" ]]; then
    /opt/containerscripts/opennms/create_conf_cassandra.py \
        ${INIT_CASSANDRA_SERVER} ${INIT_CASSANDRA_USER} ${INIT_CASSANDRA_PASSWORD} \
        > /data/container/etc/opennms.properties.d/cassandra.properties
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

# run imports
/opt/containerscripts/import.sh

# run prestart
/opt/containerscripts/prestart.sh

# init or upgrade database
/opt/opennms/bin/install -dis

# initialization of cassandra
if [[ ${INIT_CASSANDRA_ENABLE} == "true" ]]; then
    # waiting for Cassandra startup
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
    /opt/opennms/bin/newts init
fi
