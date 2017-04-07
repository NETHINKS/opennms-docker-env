# NETHINKS OpenNMS Docker environment

This repository provides a Docker environment for the open source monitoring software [OpenNMS](https://www.opennms.org). The environment is designed for testing purposes and smaller production setups. The following Docker images are the base of this environment:

image | description
------|---------------
opennms | OpenNMS itself, currently Horizon, but Meridian will be available in the future
postgres | PostgreSQL database server
nginx | Reverse proxy for the different webservers
management | Container for management of the environment (config changes, backups,...), provides an SSH login



Additionally, the following images are available at the moment:

image | description
------|---------------
alarmforwarder | The tool AlarmForwarder
cassandra | Cassandra backend for timeseries data. Should only be used for testing
grafana | Grafana with installed OpenNMS datasource.
ipv6helper | Container, which provides IPv6 NAT, to support outgoing IPv6 connections
pris | The Provisioning Integration Server
yourdashboard | Dashboard for OpenNMS alarms and outages


All images are available on [Docker Hub](https://hub.docker.com/r/nethinks/). The script scripts/container_generator/container_generator.py creates an environment based on a few questions (e.g. which images should be used, which password should be set for OpenNMS,...) and creates a docker_compose.yml file and an _init_ directory, which contains some configuration, that will be loaded on the environment's first start. 

You find some further informations in the documentation:

* [Users Guide](https://github.com/NETHINKS/opennms-docker-env/blob/master/docs/src/UserGuide.adoc). 
* [Developers Guide](https://github.com/NETHINKS/opennms-docker-env/blob/master/docs/src/DevelopmentGuide.adoc). 


If you need further help, please open an [issue](https://github.com/NETHINKS/opennms-docker-env/issues)
