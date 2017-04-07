#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Grafana Container                                                      #
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

# start Grafana
/opt/grafana/bin/grafana-server \
    -homepath /opt/grafana \
    - cfg:default.paths.plugins="/opt/grafana/data/plugins" 
