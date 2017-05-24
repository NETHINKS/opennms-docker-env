# NETHINKS OpenNMS Docker Environment: yourDashboard Container

This Image is part of the NETHINKS OpenNMS Docker environment. Please have a look at the [Github project](https://github.com/NETHINKS/opennms-docker-env), to get further informations.

It provides the tool [yourDashboard](https://github.com/michael-batz/yourDashboard "yourDashboard Website"), which can display OpenNMS alarms and outages on self defined dashboards.


## Environment Variables
The following environment variables can be used. Settings done in variables starting with 'CONF\_' will be set on every startup of the container. Settings done in variables startung with 'INIT\_' will only be applied on the container's first start.


| Variable     | Description |
|--------------|-------------|
| INIT\_OPENNMS\_URL       | URL for OpenNMS access. default: *http://opennms:8980/opennms* |
| INIT\_OPENNMS\_USER      | username for OpenNMS API access. default: *api* |
| INIT\_OPENNMS\_PASSWORD  | password for OpenNMS API access. default: *secret* |


## Interesting Ports
By default no ports were exported, but the following ports may be interesting:

| Port   | Description          |
|--------|--------------------- |
| 80     | yourDashboard WebUI  |

