#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Nginx Container                                                        #
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

# start nginx
nginx -g "daemon off;"
