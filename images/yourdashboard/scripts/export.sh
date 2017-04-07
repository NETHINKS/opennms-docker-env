#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# yourDashboard Container                                                #
# export.sh                                                              #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

DUMPDIR="/data/export/yourdashboard"

# export configuration
rm -Rf ${DUMPDIR}/*
mkdir -p ${DUMPDIR}
cp -R /data/container/etc ${DUMPDIR}/.
