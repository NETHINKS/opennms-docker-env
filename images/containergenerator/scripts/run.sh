#! /bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Container Generator Container                                          #
# run.sh                                                                 #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init
/opt/containerscripts/init.sh

# start OpenSSH server
/usr/sbin/sshd -D
