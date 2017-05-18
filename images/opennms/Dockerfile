FROM centos:7.3.1611
MAINTAINER NETHINKS GmbH <support@nethinks.com>

ARG build_locale=de_DE
ARG build_timezone=Europe/Berlin
ARG build_customrepo

# set locales
RUN localedef -c -i ${build_locale} -f UTF-8 ${build_locale}.utf-8 \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/${build_timezone} /etc/localtime

ENV LANG ${build_locale}.utf8

# install OpenNMS
RUN if [ ${build_customrepo} ]; \
        then \
            echo "[opennms-custom]" >> /etc/yum.repos.d/opennms-custom.repo; \
            echo "name=OpenNMS custom repo" >> /etc/yum.repos.d/opennms-custom.repo; \
            echo "baseurl=${build_customrepo}" >> /etc/yum.repos.d/opennms-custom.repo; \
            echo "gpgcheck=0" >> /etc/yum.repos.d/opennms-custom.repo; \
            echo "sslverify=0" >> /etc/yum.repos.d/opennms-custom.repo; \
        else \
            rpm -Uvh http://yum.opennms.org/repofiles/opennms-repo-stable-rhel7.noarch.rpm; \
            rpm --import http://yum.opennms.org/OPENNMS-GPG-KEY; \
    fi \
    && yum -y install vim net-snmp-utils postgresql jrrd jrrd2 R \
                   opennms-core \
                   opennms-webapp-jetty \
                   opennms-jmx-config-generator \
                   opennms-plugin-collector-juniper-tca \
                   opennms-plugin-collector-vtdxml-handler \
                   opennms-plugin-northbounder-jms \
                   opennms-plugin-protocol-cifs \
                   opennms-plugin-protocol-dhcp \
                   opennms-plugin-protocol-nsclient \
                   opennms-plugin-protocol-radius \
                   opennms-plugin-protocol-xml \
                   opennms-plugin-provisioning-snmp-asset \
                   opennms-plugin-provisioning-snmp-hardware-inventory \
                   opennms-plugin-ticketer-jira \
                   opennms-plugin-ticketer-otrs \
                   opennms-plugin-ticketer-rt \
                   opennms-plugin-ticketer-centric \
    && /opt/opennms/bin/runjava -s \
    # create directories for import and export
    && mkdir -p /data/init \
    && mkdir -p /data/export \
    # create directories for reference files
    && mkdir -p /data/ref \
    && mv /opt/opennms/etc /data/ref \
    && mv /opt/opennms/lib /data/ref \
    && mv /opt/opennms/jetty-webapps /data/ref/jetty-webapps \
    # create directories for container data
    && mkdir -p /data/container/etc \
    && mkdir -p /data/container/logs \
    && mkdir -p /data/rrd \
    && mkdir -p /data/container/lib_add \
    && mkdir -p /data/container/web_add \
    && mkdir -p /data/container/support/etc_diff \
    && mkdir -p /data/container/initflags \
    && cp -r /data/ref/etc/* /data/container/etc \
    && mv /var/opennms/* /data/rrd \
    && rm /opt/opennms/share \
    && rm /opt/opennms/logs \
    # create symlinks for OpenNMS
    && ln -s /data/container/etc /opt/opennms/etc \
    && ln -s /data/container/logs /opt/opennms/logs \
    && ln -s /data/rrd /opt/opennms/share \
    && mkdir /opt/opennms/jetty-webapps \
    && mkdir /opt/opennms/lib \
    # install Apache Cassandra to use the cqlsh client
    && curl -fsSLO http://www-eu.apache.org/dist/cassandra/3.10/apache-cassandra-3.10-bin.tar.gz \
    && tar -xzvf apache-cassandra-3.10-bin.tar.gz -C /opt \
    && mv /opt/apache-cassandra-3.10 /opt/cassandra \
    && rm -Rf /opt/cassandra/javadoc \
    && rm -f apache-cassandra-3.10-bin.tar.gz \
    # cleanup for a smaller Docker image
    && yum -y clean all
 

# copy start script
COPY scripts/* /opt/containerscripts/

# run.sh
CMD ["/opt/containerscripts/run.sh"]
