#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# AlarmForwarder Container                                               #
# export.sh                                                              #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${DB_SERVER+x} ]; then DB_SERVER="postgres"; fi
if [ -z ${DB_NAME+x} ]; then DB_NAME="alarmforwarder"; fi
if [ -z ${DB_USER+x} ]; then DB_USER="postgres"; fi
if [ -z ${DB_PASSWORD+x} ]; then DB_PASSWORD="postgres"; fi
DUMPDIR="/data/export/alarmforwarder"

# export configuration
rm -Rf ${DUMPDIR}/*
mkdir -p ${DUMPDIR}
cp -R /data/container/etc /data/container/logs ${DUMPDIR}/.
