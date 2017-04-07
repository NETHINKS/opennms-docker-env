#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# IPv6Helper Container                                                   #
# run.sh                                                                 #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${CONF_IP6NET+x} ]; then CONF_IP6NET="fd00:1::/48"; fi
if [ -z ${CONF_BRIDGE_INTERFACE+x} ]; then CONF_BRIDGE_INTERFACE="onmsenv0"; fi


# create IPv6 NAT rules
ip6tables -t nat -A POSTROUTING -s ${CONF_IP6NET} ! -o ${CONF_BRIDGE_INTERFACE} -j MASQUERADE

# Shutdown handler delete IPv6 NAT rules on shutdown
trap 'ip6tables -t nat -D POSTROUTING 1' EXIT

# wait until shutdown
while true;
do
    sleep 1000
done
