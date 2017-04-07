# NETHINKS OpenNMS Docker Environment: PostgreSQL Container

This Image is part of the NETHINKS OpenNMS Docker environment. Please have a look at the [Github project](https://github.com/NETHINKS/opennms-docker-env), to get further informations.

It provides the [PostgreSQL database server](https://www.postgresql.org/ "PostgreSQL Website"), which is required for OpenNMS and some further tools of the OpenNMS Docker environment like AlarmForwarder.


## Environment Variables
The following environment variables can be used:

| Variable           | Description |
|--------------------|-------------|
| POSTGRES\_USER      | initial username for the PostgreSQL database server. default *postgres* |
| POSTGRES\_PASSWORD  | initial password for the PostgreSQL database server. default *postgres* |


## Interesting Ports
By default no ports were exported, but the following ports may be interesting:

| Port   | Description          |
|--------|--------------------- |
| 5432   | PostgreSQL           |

