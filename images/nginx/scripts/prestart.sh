#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Nginx Container                                                        #
# prestart.sh                                                            #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${CONF_SUPPORTTEXT+x} ]; then CONF_SUPPORTTEXT=""; fi

# get all environment variables starting with CONF_LOCATION
LOCATIONS=$(for location in ${!CONF_LOCATION*};do echo -n "${!location} "; done)

# create nginx.conf
/opt/containerscripts/nginx/create_conf_nginx.py \
    ${LOCATIONS} \
    > /etc/nginx/nginx.conf

# create www index.html
/opt/containerscripts/nginx/create_www.py \
    ${LOCATIONS} \
    --support "${CONF_SUPPORTTEXT}" \
    > /opt/www/start/index.html

