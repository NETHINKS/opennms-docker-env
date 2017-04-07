#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# AlarmForwarder Container                                               #
# prestart.sh                                                            #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${DB_SERVER+x} ]; then DB_SERVER="postgres"; fi
if [ -z ${DB_NAME+x} ]; then DB_NAME="alarmforwarder"; fi
if [ -z ${DB_USER+x} ]; then DB_USER="postgres"; fi
if [ -z ${DB_PASSWORD+x} ]; then DB_PASSWORD="postgres"; fi

# update configuration file
sed -i 's#postgresql://.*#postgresql://'"$DB_USER"':'"$DB_PASSWORD"'@'"$DB_SERVER"'/'"$DB_NAME"'#g' \
    /opt/opennms_alarmforwarder/etc/alarmforwarder.conf
sed -i 's#;baseurl.*#baseurl = https://%%host%%/alarmforwarder#g' \
    /opt/opennms_alarmforwarder/etc/alarmforwarder.conf


# wait for Postgres startup
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
