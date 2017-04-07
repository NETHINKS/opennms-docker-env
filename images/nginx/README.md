# NETHINKS OpenNMS Docker Environment: Nginx Container

This Image is part of the NETHINKS OpenNMS Docker environment. Please have a look at the [Github project](https://github.com/NETHINKS/opennms-docker-env), to get further informations.

It provides [NGINX](https://nginx.org/en "NGINX Website"), which provides a single entrypoint to all web services of this environment.

## Environment Variables
No environment variables are required to use this image.

## Exporting Ports
By default no ports were exported, but the following ports may be interesting:

| Port | Description                                                 |
|------|------------------------------------------------------------ |
| 80   | HTTP Access                                                 |
| 443  | HTPPS Access (only if you define it in your configuration)  |

