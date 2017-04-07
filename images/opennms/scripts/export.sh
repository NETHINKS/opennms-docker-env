#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# OpenNMS Container                                                      #
# export.sh                                                              #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

/opt/containerscripts/support.sh
DUMPDIR="/data/export/opennms"
rm -Rf ${DUMPDIR:?}/*
mkdir -p ${DUMPDIR:?}
cp -R /data/container/etc /data/container/support/etc_diff /data/container/lib_add /data/container/web_add  /data/rrd/rrd ${DUMPDIR:?}/.
