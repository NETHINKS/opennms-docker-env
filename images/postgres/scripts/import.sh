#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Postgresql Container                                                   #
# import.sh                                                              #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init database, if *.sql files exists
shopt -s nullglob
if [ -d /data/init/sql/ ]; then
    for SQL_INIT_FILE in /data/init/sql/*.sql;
    do
        PGPASSWORD=$POSTGRES_PASSWORD psql -U $POSTGRES_USER -f $SQL_INIT_FILE
    done
fi
shopt -u nullglob

