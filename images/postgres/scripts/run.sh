#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Postgres Container                                                     #
# run.sh                                                                 #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

if [ -f /data/container/initflags/init ]; then
    /opt/containerscripts/prestart.sh 
else
    /opt/containerscripts/init.sh
    touch /data/container/initflags/init
fi

# start Postgres
su postgres -c "PGDATA=/data/container/pgdata/ /usr/pgsql-9.5/bin/postgres"
