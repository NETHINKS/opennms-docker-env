# NETHINKS OpenNMS Docker Environment: Cassandra Container

This Image is part of the NETHINKS OpenNMS Docker environment. Please have a look at the [Github project](https://github.com/NETHINKS/opennms-docker-env), to get further informations. 

It provides the [Apache Cassandra](http://cassandra.apache.org "Apache Cassandra Website"), which provides an alternative storage backend for OpenNMS time series data.


## Environment Variables
The following environment variables can be used:

| Variable             | Description |
|----------------------|-------------|
| CASSANDRA\_USER      | initial setting for the Cassandra user. default *cassandra* |
| CASSANDRA\_PASSWORD  | initial setting for the Cassandra password. default *cassandra* |


## Interesting Ports
By default no ports were exported, but the following ports may be interesting:

| Port   | Description          |
|--------|--------------------- |
| 9042   | CQL Access           |

