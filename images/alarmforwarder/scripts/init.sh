#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# AlarmForwarder Container                                               #
# init.sh                                                                #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${ADMIN_PASSWORD+x} ]; then ADMIN_PASSWORD="secret1234"; fi
if [ -z ${DB_SERVER+x} ]; then DB_SERVER="postgres"; fi
if [ -z ${DB_NAME+x} ]; then DB_NAME="alarmforwarder"; fi
if [ -z ${DB_USER+x} ]; then DB_USER="postgres"; fi
if [ -z ${DB_PASSWORD+x} ]; then DB_PASSWORD="postgres"; fi
if [ -z ${ONMS_URL+x} ]; then ONMS_URL="http://opennms:8980/opennms/rest"; fi
if [ -z ${ONMS_USER+x} ]; then ONMS_USER="api"; fi
if [ -z ${ONMS_PASSWORD+x} ]; then ONMS_PASSWORD="api"; fi

# init configuration: copy files from etc if exist
if [ -d /data/init/etc ] ; then
    FILECOUNT_CONF=$(ls -1 /data/init/etc | wc -l)
    if [ $FILECOUNT_CONF -gt 0 ]
        then
            cp -R /data/init/etc/* /opt/opennms_alarmforwarder/etc
    fi
fi

# execute prestart.sh
/opt/containerscripts/prestart.sh

# check, if database already exists
DB_COUNT=`PGPASSWORD=$DB_PASSWORD psql -h ${DB_SERVER} -U ${DB_USER} -q -t -c "SELECT count(*) from pg_database WHERE datname = '${DB_NAME}'"`


# if database does not exist, create and initialize it
if [ $DB_COUNT -eq 0 ]; then
    # create database schema
    echo "CREATE DATABASE ${DB_NAME}" | PGPASSWORD=${DB_PASSWORD} psql -h ${DB_SERVER} -U ${DB_USER}
    /opt/opennms_alarmforwarder/install.py

    # start AlarmForwarder in background and wait for startup
    /opt/opennms_alarmforwarder/opennms_alarmforwarder.py &
    while true
    do
        curl http://localhost:5000/ > /dev/null
        if [ $? -eq 0 ]
        then
            echo "Connection to AlarmForwarder server successful"
            break
        fi
        echo "Could not connect to AlarmForwarder server, waiting 10 sec and trying again..."
        sleep 10
    done

    # change admin password
    JSON_DATA="{\"password_old\": \"admin\", \
                \"password_new\": \"${ADMIN_PASSWORD}\", \
                \"password_new2\": \"${ADMIN_PASSWORD}\"}"
    curl \
        -Haccept:application/json \
        -Hcontent-type:application/json \
        --user admin:admin \
        -X POST \
        --data "${JSON_DATA}" \
        http://localhost:5000/password-change

    # add OpenNMS source
    JSON_DATA="{\"source_name\": \"local\", \
                \"source_url\": \"${ONMS_URL}\", \
                \"source_user\": \"${ONMS_USER}\", \
                \"source_filter\": \"\", \
                \"source_password\": \"${ONMS_PASSWORD}\"}"
    curl \
        -Haccept:application/json \
        -Hcontent-type:application/json \
        --user admin:${ADMIN_PASSWORD} \
        -X POST \
        --data "${JSON_DATA}" \
        http://localhost:5000/sources/add

    # stop AlarmForwarder
    killall opennms_alarmforwarder.py
fi
