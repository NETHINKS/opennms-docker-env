#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Nginx Container                                                        #
# init.sh                                                                #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# import Nginx configuration on init
if [ -d /data/init/etc ] && [ $(ls -1 /data/init/etc/ | wc -l) -gt 0 ];then
    cp -R /data/init/etc/* /data/container/etc/
fi

# import www data on init
if [ -d /data/init/www ] && [ $(ls -1 /data/init/www/ | wc -l) -gt 0 ];then
    cp -R /data/init/www/* /data/container/www/
fi
