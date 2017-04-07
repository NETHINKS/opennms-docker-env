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

# configuration variables
CONF_FILE=/data/container/etc/backup.conf
EXPORT_DIR=/data/export
BACKUP_TEMP=/data/container/tmp
OUT_METHOD=SMB
OUT_SMB_SHARE=//1.2.3.4/backup
OUT_SMB_FOLDER=/test
OUT_SMB_USER=username
OUT_SMB_PASSWORD=password

# load configuration
if [ -f "${CONF_FILE}" ]; then
        . "${CONF_FILE}"
else
    # if no configuration file is present, exit
    exit
fi

# create export of all containers
/opt/managerscripts/command_for_all.sh export

# create backup file
FILENAME_BASE=opennmsenv_
FILENAME_DATE=`date +%A`
FILENAME=${FILENAME_BASE}${FILENAME_DATE}.tar
tar -cvf ${BACKUP_TEMP}/${FILENAME} ${EXPORT_DIR}

# put backup file to SMB server, if configured
if [ ${OUT_METHOD} = "SMB" ]; then
cd ${BACKUP_TEMP}
smbclient ${OUT_SMB_SHARE} -U ${OUT_SMB_USER} ${OUT_SMB_PASSWORD} <<EOC
cd ${OUT_SMB_FOLDER}
put ${FILENAME}
EOC
fi

# delete temp files
rm ${BACKUP_TEMP}/${FILENAME}
