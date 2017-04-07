# NETHINKS OpenNMS Docker Environment: IPv6 Helper

This Image is part of the NETHINKS OpenNMS Docker environment. Please have a look at the [Github project](https://github.com/NETHINKS/opennms-docker-env), to get further informations. 

It provides a helper to create IPv6 NAT rules for the Docker environment. Current versions of Docker do not support IPv6 NAT. To have the same concept for IPv4 and IPv6 networking, this image was created. On startup, it simply will create a IPv6 NAT rule for the given brige interface and source addresses, that let containers communicate with the outside world via IPv6. On stop, the NAT rule will be cleaned up. A communication from the outside to specific containers is not supported at the moment. As this is a workaround for the [Docker issue #25407](https://github.com/docker/docker/issues/25407), there is only a very basic IPv6 support, to solve some problems.

The container needs to be run with *--privileged* and *--net:host*.


## Environment Variables
The following environment variables can be used:

| Variable                 | Description |
|--------------------------|-------------|
| CONF\_IP6NET             | IPv6 network for setting NAT rules. default *fd00:1::/48* |
| CONF\_BRIDGE\_INTERFACE  | name of the bridge interface for setting NAT rules. default *onmsenv0* |

## Interesting Ports
No ports were exported.
