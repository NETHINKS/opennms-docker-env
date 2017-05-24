#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# yourDashboard Container                                                #
# init.sh                                                                #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${INIT_OPENNMS_URL+x} ]; then INIT_OPENNMS_URL="http://opennms:8980/opennms"; fi
if [ -z ${INIT_OPENNMS_USER+x} ]; then INIT_OPENNMS_USER="api"; fi
if [ -z ${INIT_OPENNMS_PASSWORD+x} ]; then INIT_OPENNMS_PASSWORD="secret"; fi

# init configuration
/opt/containerscripts/yourdashboard/create_conf_dashboard.py \
    ${INIT_OPENNMS_URL} ${INIT_OPENNMS_USER} ${INIT_OPENNMS_PASSWORD} \
    > /data/container/etc/dashboard-configuration.xml

# run imports
/opt/containerscripts/import.sh
