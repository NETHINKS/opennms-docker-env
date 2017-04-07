#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Grafana Container                                                      #
# init.sh                                                                #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${ADMIN_PASSWORD+x} ]; then ADMIN_PASSWORD="secret1234"; fi
if [ -z ${ONMS_URL+x} ]; then ONMS_URL="http://opennms:8980/opennms"; fi
if [ -z ${ONMS_USER+x} ]; then ONMS_USER="api"; fi
if [ -z ${ONMS_PASSWORD+x} ]; then ONMS_PASSWORD="api"; fi
DATA_INIT=1

# init configuration: copy files from conf if exist
if [ -d /data/init/conf ] ; then
    FILECOUNT_CONF=$(ls -1 /data/init/conf | wc -l)
    if [ $FILECOUNT_CONF -gt 0 ]
        then
            cp -R /data/init/conf/* /data/container/conf
            DATA_INIT=0
    fi
fi

# init grafana data dir: copy files from data if exist
if [ -d /data/init/data ] ; then
    FILECOUNT_DATA=$(ls -1 /data/init/data | wc -l)
    if [ $FILECOUNT_DATA -gt 0 ]
        then
            cp -R /data/init/data/* /data/container/data
            DATA_INIT=0
    fi
fi

#if existing grafana data were not imported, init new data
if [ $DATA_INIT -gt 0 ]; then
    # update configuration file
    sed -i 's#;root_url.*#root_url = %(protocol)s://%(domain)s:%(http_port)s/grafana/#g' \
        /opt/grafana/conf/custom.ini
    sed -i 's#check_for_updates =.*#check_for_updates = false#g' \
        /opt/grafana/conf/custom.ini
    sed -i 's#;default_theme.*#default_theme = light#g' \
        /opt/grafana/conf/custom.ini


    # start Grafana in background and wait for startup
    /opt/grafana/bin/grafana-server \
        -homepath /opt/grafana \
        - cfg:default.paths.plugins="/opt/grafana/data/plugins" &
    while true
    do
        curl http://localhost:3000/ > /dev/null
        if [ $? -eq 0 ]
        then
            echo "Connection to Grafana server successful"
            break
        fi
        echo "Could not connect to Grafana server, waiting 10 sec and trying again..."
        sleep 10
    done

    # change admin password
    JSON_DATA="{\"oldPassword\": \"admin\", \
                \"newPassword\": \"${ADMIN_PASSWORD}\", \
                \"confirmNew\": \"${ADMIN_PASSWORD}\"}"
    curl \
        -Haccept:application/json \
        -Hcontent-type:application/json \
        --user admin:admin \
        -X PUT \
        --data "${JSON_DATA}" \
        http://localhost:3000/api/user/password

    # add OpennMS datasource
    JSON_DATA="{\"name\": \"default\", \
                \"type\": \"opennms-datasource\", \
                \"url\": \"${ONMS_URL}\", \
                \"access\": \"proxy\", \
                \"basicAuth\": true, \
                \"basicAuthUser\": \"${ONMS_USER}\", \
                \"basicAuthPassword\": \"${ONMS_PASSWORD}\", \
                \"isDefault\": true}"
    curl \
        -Haccept:application/json \
        -Hcontent-type:application/json \
        --user admin:${ADMIN_PASSWORD} \
        -X POST \
        --data "${JSON_DATA}" \
        http://localhost:3000/api/datasources

    # stop Grafana
    killall grafana-server

fi
