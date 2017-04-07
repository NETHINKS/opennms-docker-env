#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Cassandra Container                                                    #
# prestart.sh                                                            #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# update cassandra seeds
su cassandra -c "sed -i 's/- seeds:.*/- seeds: \"${HOSTNAME}\"/' /data/container/cassandra/conf/cassandra.yaml" 
