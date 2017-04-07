#! /bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Management Container                                                   #
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

# start crond in background
/usr/sbin/crond -s

# start OpenSSH server
/usr/sbin/sshd -D
