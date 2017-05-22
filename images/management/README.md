# NETHINKS OpenNMS Docker Environment: Management Container

This Image is part of the NETHINKS OpenNMS Docker environment. Please have a look at the [Github project](https://github.com/NETHINKS/opennms-docker-env), to get further informations.

It provides management access to the environment via SSH login. You can login with username *root* and the password set with the environment variable *SSH_PASSWORD*.


## Environment Variables
The following environment variables can be used. Settings done in variables starting with 'CONF\_' will be set on every startup of the container. Settings done in variables startung with 'INIT\_' will only be applied on the container's first start.

| Variable     | Description |
|--------------|-------------|
| CONF\_SSH\_PASSWORD | password for SSH access. default *admin* |
| CONF\_BACKUP\_ENABLED | *TRUE*, if the backup cronjob should be enabled. default *FALSE* |
| CONF\_BACKUP\_URL | URL for backups. default *smb://user:pass@1.2.3.4/backup/test* |


## Interesting Ports
By default no ports were exported, but the following ports may be interesting:

| Port | Description          |
|------|--------------------- |
| 22   | SSH access           |
