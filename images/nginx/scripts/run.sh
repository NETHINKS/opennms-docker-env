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

# init on first start
if [ ! -f /data/container/initflags/init ]; then
    /opt/containerscripts/init.sh
    touch /data/container/initflags/init
fi

# prestart
/opt/containerscripts/prestart.sh 

# start nginx
nginx -g "daemon off;"
