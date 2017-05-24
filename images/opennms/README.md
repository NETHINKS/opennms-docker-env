# Docker Image for OpenNMS

This Image is part of the NETHINKS OpenNMS Docker environment. Please have a look at the [Github project](https://github.com/NETHINKS/opennms-docker-env), to get further informations.

It provides [OpenNMS](https://opennms.org "OpenNMS Website") itself, an open souce network management plattform. 


## Environment Variables
The following environment variables can be used. Settings done in variables starting with 'CONF\_' will be set on every startup of the container. Settings done in variables startung with 'INIT\_' will only be applied on the container's first start.


| Variable     | Description |
|--------------|-------------|
| INIT\_DB\_SERVER    | initial setting for database server. default: *dbserver* |
| INIT\_DB\_USER      | initial setting for database user name. default: *postgres* |
| INIT\_DB\_PASSWORD  | initial setting for database password. default: *secret* |
| INIT\_CASSANDRA\_ENABLE | enable the usage of cassandra(*true* or *false*). default: *false* |
| INIT\_CASSANDRA\_SERVER | the cassandra server to use. default: *cassandra* |
| INIT\_CASSANDRA\_USER | username for connecting to cassandra. default: *cassandra* |
| INIT\_CASSANDRA\_PASSWORD | password for connecting to cassandra. default: *secret* |
| INIT\_ADMIN\_USER | username for the OpenNMS admin user. default: *admin* |
| INIT\_ADMIN\_PASSWORD | password for the OpenNMS admin user. default: *admin* |
| INIT\_API\_USER | username for the OpenNMS api access user. default: *api* |
| INIT\_API\_PASSWORD | password for the OpenNMS api access user. default: *api* |


## Exporting Ports
No ports are exported by default, but the following ports may be interesting for exporting:

| Port | Description          |
|------|--------------------- |
| 162  | SNMP traps           |
| 514  | Syslog messages      |
| 5817 | OpenNMS Eventd       |
| 8980 | OpenNMS WebUI (HTTP) |
