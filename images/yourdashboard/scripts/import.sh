#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# yourDashboard Container                                                #
# import.sh                                                              #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# import configuration files
if [ -d /data/init/etc/ ] ; then
    cp -R /data/init/etc/* /data/container/etc/
fi
