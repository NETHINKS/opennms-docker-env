#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# OpenNMS Container                                                      #
# import.sh                                                              #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${DB_SERVER+x} ]; then DB_SERVER=dbserver; fi
if [ -z ${DB_USER+x} ]; then DB_USER=postgres; fi
if [ -z ${DB_PASSWORD+x} ]; then DB_PASSWORD=secret; fi

# init configuration: copy files from etc_init if exist
if [ -d /data/init/etc ] ; then
    FILECOUNT_ETC_INIT=$(ls -1 /data/init/etc | wc -l)
    if [ $FILECOUNT_ETC_INIT -gt 0 ]
        then
            cp -R /data/init/etc/* /data/container/etc
    fi
fi

# import additional lib files in container
if [ -d /data/init/lib_add ] ; then
    FILECOUNT_LIB_ADD=`ls -1 /data/init/lib_add | wc -l`
    if [ $FILECOUNT_LIB_ADD -gt 0 ]
        then
            cp -R /data/init/lib_add/* /data/container/lib_add/
    fi
fi

# import additional web files in container
if [ -d /data/init/web_add ] ; then
    FILECOUNT_WEB_ADD=`ls -1 /data/init/web_add | wc -l`
    if [ $FILECOUNT_WEB_ADD -gt 0 ]
        then
            cp -R /data/init/web_add/* /data/container/web_add/
    fi
fi

# import RRD files if exists
if [ -d /data/init/rrd/ ]; then
    cp -R /data/init/rrd/* /data/rrd/rrd/
fi

