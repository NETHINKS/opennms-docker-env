# NETHINKS OpenNMS Docker Environment: AlarmForwarder Container

This Image is part of the NETHINKS OpenNMS Docker environment. Please have a look at the [Github project](https://github.com/NETHINKS/opennms-docker-env), to get further informations.

It provides the tool [AlarmForwarder](https://github.com/NETHINKS/opennms_alarmforwarder "AlarmForwarder Website"), which can notify users based on OpenNMS alarms. The data were stored in a PostgreSQL database, which needs to be present.


## Environment Variables
The following environment variables can be used:

| Variable        | Description |
|-----------------|-------------|
| ADMIN\_PASSWORD | initial password for the AlarmForwarder WebUI. default *secret1234* |
| DB\_SERVER      | initial setting for the PostgreSQL database server. default *postgres* |
| DB\_NAME        | initial setting for the PostgreSQL database name. default *alarmforwarder* |
| DB\_USER        | initial setting for the PostgreSQL database user. default *postgres* |
| DB\_PASSWORD    | initial setting for the PostgreSQL database password. default *postgres* |
| ONMS\_URL       | initial setting for the OpenNMS REST URL. default *http://opennms:8980/opennms/rest* |
| ONMS\_USER      | initial setting for the OpenNMS REST user. default *api* |
| ONMS\_PASSWORD  | initial setting for the OpenNMS REST password. default *api* |


## Interesting Ports
By default no ports were exported, but the following ports may be interesting:

| Port   | Description          |
|--------|--------------------- |
| 5000   | WebUI                |

