# NETHINKS OpenNMS Docker Environment: Grafana Container

This Image is part of the NETHINKS OpenNMS Docker environment. Please have a look at the [Github project](https://github.com/NETHINKS/opennms-docker-env), to get further informations. 

It provides the tool [Grafana](https://grafana.net "Grafana Website") with an installed OpenNMS datasource, which can display dashboards with graphs based on collected values from OpenNMS.


## Environment Variables
The following environment variables can be used:

| Variable        | Description |
|-----------------|-------------|
| ADMIN\_PASSWORD | initial password for the Grafana WebUI. default *secret1234* |
| ONMS\_URL       | initial setting for the OpenNMS REST URL. default *http://opennms:8980/opennms* |
| ONMS\_USER      | initial setting for the OpenNMS REST user. default *api* |
| ONMS\_PASSWORD  | initial setting for the OpenNMS REST password. default *api* |


## Interesting Ports
By default no ports were exported, but the following ports may be interesting:

| Port   | Description          |
|--------|--------------------- |
| 3000   | Grafana WebUI        |

