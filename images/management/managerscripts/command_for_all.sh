#! /bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Management Container                                                   #
# command_for_all.sh                                                     #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# Send command to all container of this opennms-docker-environment

if [ "${1}" != "-C" ]; then
  command=/opt/containerscripts/"${1}".sh
else
  command="${2}"
fi

# Get container pre- and suffix

manager_container_name=$(/usr/local/bin/docker ps --format '{{.ID}}:{{.Names}}' | grep "${HOSTNAME}" | awk -F':' '{print $2}')
# docker ps --format '{{.ID}}:{{.Names}}' - lists all running container as a table (container id; container name) seperatet by
# grep ${HOSTNAME}                        - The Hostname of a container is it's ID. The entry for the management container is selected.
prefix=$(echo "${manager_container_name}" | awk -F"management" '{print $1}')
suffix=$(echo "${manager_container_name}" | awk -F"management" '{print $2}')


# list of all container of this opennms-docker-environment
containerlist=$(/usr/local/bin/docker ps --format '{{.Names}}' | grep "${prefix}".*"${suffix}")

for container in ${containerlist}
do
  /usr/local/bin/docker exec "${container}" "${command}"
done
