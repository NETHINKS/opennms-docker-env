# NETHINKS OpenNMS Docker Environment: Management Container

This Image is part of the NETHINKS OpenNMS Docker environment. Please have a look at the [Github project](https://github.com/NETHINKS/opennms-docker-env), to get further informations.

It provides management access to the environment via SSH login. You can login with username *root* and the password set with the environment variable *SSH_PASSWORD*.


## Environment Variables
The following environment variables can be used:

| Variable     | Description |
|--------------|-------------|
| SSH\_PASSWORD | password for SSH access. default *admin* |


## Interesting Ports
By default no ports were exported, but the following ports may be interesting:

| Port | Description          |
|------|--------------------- |
| 22   | SSH access           |
