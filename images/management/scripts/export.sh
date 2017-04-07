#! /bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Management Container                                                   #
# export.sh                                                              #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# export backup configuration
DUMPDIR="/data/export/management"
rm -Rf ${DUMPDIR:?}/*
mkdir -p ${DUMPDIR:?}
cp -R /data/container/etc ${DUMPDIR:?}/.
