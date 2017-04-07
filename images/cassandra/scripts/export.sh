#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Cassandra Container                                                    #
# export.sh                                                              #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${CASSANDRA_USER+x} ]; then CASSANDRA_USER="cassandra"; fi
if [ -z ${CASSANDRA_PASSWORD+x} ]; then CASSANDRA_PASSWORD="cassandra"; fi


# create directory
DUMPDIR="/data/export/cassandra"
rm -Rf ${DUMPDIR}/*
mkdir -p ${DUMPDIR}

# export configuration
cp -R /data/container/cassandra/conf ${DUMPDIR}

# export schema from non system Keyspaces
mkdir -p ${DUMPDIR}/schema
CQL="DESC KEYSPACES;"
KEYSPACES=`su cassandra -c "/opt/cassandra/bin/cqlsh -u ${CASSANDRA_USER} -p ${CASSANDRA_PASSWORD} -e \"${CQL}\" ${HOSTNAME}"`
for KEYSPACE in ${KEYSPACES}
do
    if [[ $KEYSPACE != system* ]] ;
    then
        CQL="DESC KEYSPACE ${KEYSPACE};"
        SCHEMAFILE="${DUMPDIR}/schema/${KEYSPACE}"
        su cassandra -c "/opt/cassandra/bin/cqlsh -u ${CASSANDRA_USER} -p ${CASSANDRA_PASSWORD} -e \"${CQL}\" ${HOSTNAME}" > ${SCHEMAFILE}
    fi
done 

# create and export snapshot
mkdir -p ${DUMPDIR}/snapshot
/opt/cassandra/bin/nodetool snapshot -t export
SNAPSHOT_PATHS=`find /opt/cassandra/data/data/ -name "export" -type d`
for SNAPSHOT_PATH in ${SNAPSHOT_PATHS}
do
    SNAPSHOT_SUBDIR=${SNAPSHOT_PATH#/opt/cassandra/data/data}
    TARGET_SUBDIR=${SNAPSHOT_SUBDIR%/snapshots/export}
    if [[ $TARGET_SUBDIR != /system* ]] ;
    then
        TARGET_DIR=${DUMPDIR}/snapshot/${TARGET_SUBDIR}
        mkdir -p ${TARGET_DIR}
        cp ${SNAPSHOT_PATH}/* ${TARGET_DIR}
    fi
done
/opt/cassandra/bin/nodetool clearsnapshot -t export
