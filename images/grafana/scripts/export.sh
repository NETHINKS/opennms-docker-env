#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Grafana Container                                                      #
# export.sh                                                              #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

DUMPDIR="/data/export/grafana"

# export configuration and grafana data
rm -Rf ${DUMPDIR}/*
mkdir -p ${DUMPDIR}
cp -R /data/container/conf /data/container/data ${DUMPDIR}/.


