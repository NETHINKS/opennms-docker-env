FROM centos:7.3.1611
MAINTAINER NETHINKS GmbH <support@nethinks.com>

ARG build_locale=de_DE
ARG build_timezone=Europe/Berlin

# set locales
RUN localedef -c -i ${build_locale} -f UTF-8 ${build_locale}.utf-8 \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/${build_timezone} /etc/localtime

ENV LANG ${build_locale}.utf8

# install Grafana
RUN yum -y install psmisc.x86_64 \
    && curl -fsSLO https://grafanarel.s3.amazonaws.com/builds/grafana-3.1.1-1470047149.linux-x64.tar.gz \
    && tar -xzvf grafana-3.1.1-1470047149.linux-x64.tar.gz -C /opt \
    && rm -f grafana-3.1.1-1470047149.linux-x64.tar.gz \
    && mv /opt/grafana-3.1.1-1470047149 /opt/grafana \
    && cp /opt/grafana/conf/sample.ini /opt/grafana/conf/custom.ini \
    # create directories for data
    && mkdir -p /data/init \
    && mkdir -p /data/export \
    && mkdir -p /data/container/initflags \
    && mkdir -p /data/container/data \
    && mv /opt/grafana/conf /data/container \
    && ln -s /data/container/conf /opt/grafana/conf \
    && ln -s /data/container/data /opt/grafana/data \
    # install OpenNMS datasource
    && /opt/grafana/bin/grafana-cli --pluginsDir "/opt/grafana/data/plugins" plugins install opennms-datasource \
    # cleanup for a smaller Docker image
    && yum -y clean all
 

# copy start script
COPY scripts/* /opt/containerscripts/

# run.sh
CMD ["/opt/containerscripts/run.sh"]
