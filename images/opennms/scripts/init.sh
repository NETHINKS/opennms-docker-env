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
if [ -z ${DB_SERVER+x} ]; then DB_SERVER=dbserver; fi
if [ -z ${DB_USER+x} ]; then DB_USER=postgres; fi
if [ -z ${DB_PASSWORD+x} ]; then DB_PASSWORD=secret; fi

# waiting for Postgres startup
while true
do
    PGPASSWORD=$DB_PASSWORD psql -h $DB_SERVER -U $DB_USER -c "\l"
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

# initialization of newts
if [[ ${ENABLE_NEWTS} == "true" ]]; then
    # waiting for Cassandra startup
    while true
    do
        /opt/cassandra/bin/cqlsh -u cassandra -p $DB_PASSWORD cassandra -e "DESC KEYSPACES"
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
