# Docker Image for OpenNMS

This Image is part of the NETHINKS OpenNMS Docker environment. Please have a look at the [Github project](https://github.com/NETHINKS/opennms-docker-env), to get further informations.

It provides [OpenNMS](https://opennms.org "OpenNMS Website") itself, an open souce network management plattform. 


## Environment Variables
The following environment variables can be used:

| Variable     | Description |
|--------------|-------------|
| DB\_SERVER    | initial setting for database server. default: *dbserver* |
| DB\_USER      | initial setting for database user name. default: *postgres* |
| DB\_PASSWORD  | initial setting for database password. default: *secret* |
| ENABLE\_NEWTS | trigger the initialization of the newts database. default: *false* |


## Exporting Ports
No ports are exported by default, but the following ports may be interesting for exporting:

| Port | Description          |
|------|--------------------- |
| 162  | SNMP traps           |
| 514  | Syslog messages      |
| 5817 | OpenNMS Eventd       |
| 8980 | OpenNMS WebUI (HTTP) |
