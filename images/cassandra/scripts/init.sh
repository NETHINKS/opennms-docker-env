#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Cassandra Container                                                    #
# init.sh                                                                #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z "${CASSANDRA_USER+x}" ]; then CASSANDRA_USER="cassandra"; fi
if [ -z "${CASSANDRA_PASSWORD+x}" ]; then CASSANDRA_PASSWORD="cassandra"; fi
CASSANDRA_PASSWORD_TEMP="noaccess";


# init Cassandra configuation
su cassandra -c "sed -i 's/cluster_name:.*/cluster_name: '\"'\"'Cassandra Cluster'\"'\"'/g' /data/container/cassandra/conf/cassandra.yaml" 
su cassandra -c "sed -i 's/listen_address:.*/# listen_address: localhost/g' /data/container/cassandra/conf/cassandra.yaml" 
su cassandra -c "sed -i 's/# listen_interface:.*/listen_interface: eth0/g' /data/container/cassandra/conf/cassandra.yaml" 
su cassandra -c "sed -i 's/rpc_address:.*/# rpc_address: localhost/g' /data/container/cassandra/conf/cassandra.yaml" 
su cassandra -c "sed -i 's/# rpc_interface:.*/rpc_interface: eth0/g' /data/container/cassandra/conf/cassandra.yaml" 
su cassandra -c "sed -i 's/authenticator: AllowAllAuthenticator/authenticator: PasswordAuthenticator/g' /data/container/cassandra/conf/cassandra.yaml" 
su cassandra -c "sed -i 's/- seeds:.*/- seeds: \"${HOSTNAME}\"/' /data/container/cassandra/conf/cassandra.yaml" 

# start Cassandra in background and wait for startup
su cassandra -c "/opt/cassandra/bin/cassandra"
while true
do
    su cassandra -c "/opt/cassandra/bin/cqlsh -u cassandra -p cassandra -e \"DESC KEYSPACES\" ${HOSTNAME}"
    if [ $? -eq 0 ]
    then
        echo "Connection to Cassandra server successful"
        break
    fi
    echo "Could not connect to Cassandra server, waiting 10 sec and trying again..."
    sleep 10
done

# create user cassandra, set password to temp value to deny access during init
CQL="ALTER KEYSPACE system_auth WITH replication = {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '1'};"
su cassandra -c "/opt/cassandra/bin/cqlsh -u cassandra -p cassandra -e \"${CQL}\" ${HOSTNAME}"

if [ "$CASSANDRA_USER" != 'cassandra' ]; then
    CQL="CREATE USER '${CASSANDRA_USER}' WITH PASSWORD '${CASSANDRA_PASSWORD_TEMP}' SUPERUSER;"
    su cassandra -c "/opt/cassandra/bin/cqlsh -u cassandra -p cassandra -e \"${CQL}\" ${HOSTNAME}"
fi
CQL="ALTER USER '${CASSANDRA_USER}' WITH PASSWORD '${CASSANDRA_PASSWORD_TEMP}';"
su cassandra -c "/opt/cassandra/bin/cqlsh -u cassandra -p cassandra -e \"${CQL}\" ${HOSTNAME}"


# waiting for Cassandra to take over the authentication information
while true
do
    su cassandra -c "/opt/cassandra/bin/cqlsh -u ${CASSANDRA_USER} -p ${CASSANDRA_PASSWORD_TEMP} -e \"DESC KEYSPACES\" ${HOSTNAME}"
    if [ $? -eq 0 ]
    then
        echo "Authentication information has been taken over."
        break
    fi
    echo "Could not connect to Cassandra server, waiting 10 sec and trying again..."
    sleep 10
done


# import schema for keyspaces if defined
shopt -s nullglob
if [ -d /data/init/schema/ ] ;
then
    for SCHEMA in /data/init/schema/*;
    do
        su cassandra -c "/opt/cassandra/bin/cqlsh -u ${CASSANDRA_USER} -p ${CASSANDRA_PASSWORD_TEMP} -f \"${SCHEMA}\" ${HOSTNAME}"
    done
fi


# import snapshots if defined
if [ -d /data/init/snapshot/ ] ;
then
    SNAPSHOTS=$(find /data/init/snapshot/ -type d -mindepth 2)
    for SNAPSHOT in ${SNAPSHOTS}
    do
        su cassandra -c "/opt/cassandra/bin/sstableloader -d ${HOSTNAME} -u ${CASSANDRA_USER} -pw ${CASSANDRA_PASSWORD_TEMP} ${SNAPSHOT} -f /opt/cassandra/conf/cassandra.yaml"
    done
fi
shopt -u nullglob

# change temp password to correct one
CQL="ALTER USER '${CASSANDRA_USER}' WITH PASSWORD '${CASSANDRA_PASSWORD}';"
su cassandra -c "/opt/cassandra/bin/cqlsh -u ${CASSANDRA_USER} -p ${CASSANDRA_PASSWORD_TEMP} -e \"${CQL}\" ${HOSTNAME}"

# stop background running Cassandra
killall java
