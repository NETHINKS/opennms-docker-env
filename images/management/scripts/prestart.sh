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

# init CONF_* environment variables
if [ -z ${CONF_SSH_PASSWORD+x} ]; then CONF_SSH_PASSWORD=admin; fi
if [ -z ${CONF_BACKUP_ENABLED+x} ]; then CONF_BACKUP_ENABLED="FALSE"; fi
if [ -z ${CONF_BACKUP_URL+x} ]; then CONF_BACKUP_URL="smb://user:pass@1.2.3.4/backup/test"; fi
echo "" > /etc/environment
echo "CONF_BACKUP_ENABLED=${CONF_BACKUP_ENABLED}" >> /etc/environment
echo "CONF_BACKUP_URL=${CONF_BACKUP_URL}" >> /etc/environment

# set root password
echo "${CONF_SSH_PASSWORD}" | passwd root --stdin
