#! /bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Management Container                                                   #
# init.sh                                                                #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# copy backup config files, if exist
if [ -d /data/init/etc ] ; then
    FILECOUNT_ETC_INIT=$(ls -1 /data/init/etc | wc -l)
    if [ $FILECOUNT_ETC_INIT -gt 0 ]
        then
            cp -R /data/init/etc/* /data/container/etc
    fi
fi
