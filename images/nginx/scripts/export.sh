#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Nginx Container                                                        #
# export.sh                                                              #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# create directory
DUMPDIR="/data/export/nginx"
rm -Rf ${DUMPDIR}/*
mkdir -p ${DUMPDIR}

# export configuration
cp -R /data/container/etc ${DUMPDIR}/.

# export www data
cp -R /data/container/www ${DUMPDIR}/.
