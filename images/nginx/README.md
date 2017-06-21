# NETHINKS OpenNMS Docker Environment: Nginx Container

This Image is part of the NETHINKS OpenNMS Docker environment. Please have a look at the [Github project](https://github.com/NETHINKS/opennms-docker-env), to get further informations.

It provides [NGINX](https://nginx.org/en "NGINX Website"), which provides a single entrypoint to all web services of this environment.

## Environment Variables
The following environment variables can be used. Settings done in variables starting with 'CONF\_' will be set on every startup of the container. Settings done in variables startung with 'INIT\_' will only be applied on the container's first start.

| Variable     | Description |
|--------------|-------------|
| INIT\_SSL\_CN    | SSL Cert/CSR CN default: *localhost* |
| INIT\_SSL\_ORG      | SSL Cert/CSR organisation. default: *NETHINKS GmbH* |
| INIT\_SSL\_UNIT  | SSL Cert/CSR unit. default: *PSS* |
| INIT\_SSL\_COUNTRY  | SSL Cert/CSR country. default: *DE* |
| INIT\_SSL\_STATE  | SSL Cert/CSR state. default: *HESSE* |
| INIT\_SSL\_LOCATION  | SSL Cert/CSR location. default: *Fulda* |
| INIT\_SSL\_VALIDDAYS  | SSL Cert/CSR valid days. default: *3650* |
| INIT\_SSL\_KEYLENGTH  | SSL Cert/CSR keylength. default: *4096* |
| INIT\_SSL\_DIGEST  | SSL Cert/CSR digest. default: *sha384* |
| CONF\_SUPPORTTEXT  | Text for having support info on the start page. default: *empty* |
| CONF\_LOCATION\_*  | Locations for nginx config. Format: <name>;<location>;<url>. |


## Exporting Ports
By default no ports were exported, but the following ports may be interesting:

| Port | Description                                                 |
|------|------------------------------------------------------------ |
| 80   | HTTP Access                                                 |
| 443  | HTTPS Access (only if you define it in your configuration)  |

