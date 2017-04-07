#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# PRIS Container                                                         #
# import.sh                                                              #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# import requisition files in container
if [ -d /data/init/requisitions ] ; then
    FILECOUNT_ADD=`ls -1 /data/init/requisitions | wc -l`
    if [ $FILECOUNT_ADD -gt 0 ]
        then
            cp -r /data/init/requisitions/* /data/container/requisitions
    fi
fi
