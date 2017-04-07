#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Cassandra Container                                                    #
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

# start cassandra
su cassandra -c "/opt/cassandra/bin/cassandra -f"
