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
if [ -z ${BACKUP_ENABLED+x} ]; then BACKUP_ENABLED="FALSE"; fi
if [ -z ${BACKUP_URL+x} ]; then BACKUP_URL="smb://user:pass@1.2.3.4/backup/test"; fi
echo "" > /etc/environment
echo "BACKUP_ENABLED=${BACKUP_ENABLED}" >> /etc/environment
echo "BACKUP_URL=${BACKUP_URL}" >> /etc/environment

# set root password
echo "${SSH_PASSWORD}" | passwd root --stdin
