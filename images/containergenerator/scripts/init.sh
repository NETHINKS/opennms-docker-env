#! /bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Container Generator Container                                          #
# init.sh                                                                #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${SSH_PASSWORD+x} ]; then SSH_PASSWORD=admin; fi

# set root password
echo "${SSH_PASSWORD}" | passwd root --stdin
