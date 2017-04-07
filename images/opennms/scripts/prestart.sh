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
if [ -z ${DB_SERVER+x} ]; then DB_SERVER=dbserver; fi
if [ -z ${DB_USER+x} ]; then DB_USER=postgres; fi
if [ -z ${DB_PASSWORD+x} ]; then DB_PASSWORD=secret; fi

# remove old directories and symlinks
rm -Rf /opt/opennms/lib/*
rm -Rf /opt/opennms/jetty-webapps/*

# update database configuration on startup
sed -i 's/user-name=".*"/user-name="'"$DB_USER"'"/g' /data/container/etc/opennms-datasources.xml
sed -i 's/password=".*"/password="'"$DB_PASSWORD"'"/g' /data/container/etc/opennms-datasources.xml
sed -i 's/localhost/'"$DB_SERVER"'/g' /data/container/etc/opennms-datasources.xml

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
    PGPASSWORD=$DB_PASSWORD psql -h $DB_SERVER -U $DB_USER -c "\l"
    if [ $? -eq 0 ]
    then
        echo "Connection to PostgreSQL server successful"
        break
    fi
    echo "Could not connect to PostgreSQL server, waiting 10 sec and trying again..."
    sleep 10
done

# waiting for Cassandra startup if newts is enabled
if [[ ${ENABLE_NEWTS} == "true" ]]; then
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
fi
