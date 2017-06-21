#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# Nginx Container                                                        #
# init.sh                                                                #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# init environment variables
if [ -z ${INIT_SSL_CN+x} ]; then INIT_SSL_CN=localhost; fi
if [ -z ${INIT_SSL_ORG+x} ]; then INIT_SSL_ORG=NETHINKS; fi
if [ -z ${INIT_SSL_UNIT+x} ]; then INIT_SSL_UNIT=PSS; fi
if [ -z ${INIT_SSL_COUNTRY+x} ]; then INIT_SSL_COUNTRY=DE; fi
if [ -z ${INIT_SSL_STATE+x} ]; then INIT_SSL_STATE=HESSE; fi
if [ -z ${INIT_SSL_LOCATION+x} ]; then INIT_SSL_LOCATION=Fulda; fi
if [ -z ${INIT_SSL_VALIDDAYS+x} ]; then INIT_SSL_VALIDDAYS=3650; fi
if [ -z ${INIT_SSL_KEYLENGTH+x} ]; then INIT_SSL_KEYLENGTH=4096; fi
if [ -z ${INIT_SSL_DIGEST+x} ]; then INIT_SSL_DIGEST=sha384; fi

# create ssl key/cert/csr
/opt/containerscripts/nginx/create_certificate.py \
    "${INIT_SSL_ORG}" "${INIT_SSL_UNIT}" "${INIT_SSL_COUNTRY}" \
    "${INIT_SSL_STATE}" "${INIT_SSL_LOCATION}" "${INIT_SSL_CN}" \
    "${INIT_SSL_VALIDDAYS}" "${INIT_SSL_KEYLENGTH}" "${INIT_SSL_DIGEST}" \
    /data/container/ssl/

# overwrite SSL certificates on init
if [ -d /data/init/ssl ] && [ $(ls -1 /data/init/ssl/ | wc -l) -gt 0 ];then
    cp -R /data/init/ssl/* /data/container/ssl/
fi
