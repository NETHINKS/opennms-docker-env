#! /bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Management Container                                                   #
# backup.sh                                                              #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${CONF_BACKUP_ENABLED+x} ]; then CONF_BACKUP_ENABLED="FALSE"; fi
if [ -z ${CONF_BACKUP_URL+x} ]; then CONF_BACKUP_URL="smb://user:pass@1.2.3.4/backup/test"; fi

# configuration variables
EXPORT_DIR=/data/export
BACKUP_TEMP=/data/container/tmp

# exit, if backup is disabled
if [ "${CONF_BACKUP_ENABLED}" != "TRUE" ]; then
    exit
fi

# check backup protocol
URL_PROTOCOL=$(echo $CONF_BACKUP_URL | sed -e 's#^\(.*\)://.*$#\1#g')

# create export of all containers
/opt/managerscripts/command_for_all.sh export

# create backup file
FILENAME_BASE=opennmsenv_
FILENAME_DATE=`date +%A`
FILENAME=${FILENAME_BASE}${FILENAME_DATE}.tar
tar -cvf ${BACKUP_TEMP}/${FILENAME} ${EXPORT_DIR}


# put backup file to SMB server, if configured
if [ ${URL_PROTOCOL} = "smb" ]; then
URL_USER=$(echo $CONF_BACKUP_URL | sed -e 's#^.*://\(.*\):\(.*\)@\(.*\)$#\1#g')
URL_PASS=$(echo $CONF_BACKUP_URL | sed -e 's#^.*://\(.*\):\(.*\)@\(.*\)$#\2#g')
URL_SHARE=$(echo $CONF_BACKUP_URL | sed -e 's#^.*://\(.*\):\(.*\)@\([^/]\+/[^/]\+\)/\(.*\)$#\3#g')
URL_DIR=$(echo $CONF_BACKUP_URL | sed -e 's#^.*://\(.*\):\(.*\)@\([^/]\+/[^/]\+\)/\(.*\)$#\4#g')
cd ${BACKUP_TEMP}
smbclient //${URL_SHARE} -U ${URL_USER} ${URL_PASS} <<EOC
cd ${URL_DIR}
put ${FILENAME}
EOC
fi

# put backup file to FTP server, if configured
if [ ${URL_PROTOCOL} = "ftp" ]; then
URL_USER=$(echo $CONF_BACKUP_URL | sed -e 's#^.*://\(.*\):\(.*\)@\(.*\)$#\1#g')
URL_PASS=$(echo $CONF_BACKUP_URL | sed -e 's#^.*://\(.*\):\(.*\)@\(.*\)$#\2#g')
URL_SERVER=$(echo $CONF_BACKUP_URL | sed -e 's#^.*://\(.*\):\(.*\)@\([^/]\+\)/\(.*\)$#\3#g')
URL_DIR=$(echo $CONF_BACKUP_URL | sed -e 's#^.*://\(.*\):\(.*\)@\([^/]\+\)/\(.*\)$#\4#g')

cd ${BACKUP_TEMP}
ftp -n ${URL_SERVER} <<EOC
quote USER ${URL_USER}
quote PASS ${URL_PASS}
cd ${URL_DIR}
put ${FILENAME}
quit
EOC
fi

# delete temp files
rm ${BACKUP_TEMP}/${FILENAME}
