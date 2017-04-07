#! /bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Management Container                                                   #
# prestart.sh                                                            #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${SSH_PASSWORD+x} ]; then SSH_PASSWORD=admin; fi

# set root password
echo "${SSH_PASSWORD}" | passwd root --stdin
