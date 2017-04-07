#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# PRIS Container                                                         #
# export.sh                                                              #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

DUMPDIR="/data/export/pris"

# export configuration
rm -Rf ${DUMPDIR}/*
mkdir -p ${DUMPDIR}
cp -R /data/container/requisitions ${DUMPDIR}/.
