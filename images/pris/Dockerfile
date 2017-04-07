FROM centos:7.3.1611
MAINTAINER NETHINKS GmbH <support@nethinks.com>

ARG build_locale=de_DE
ARG build_timezone=Europe/Berlin

# set locales
RUN localedef -c -i ${build_locale} -f UTF-8 ${build_locale}.utf-8 \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/${build_timezone} /etc/localtime

ENV LANG ${build_locale}.utf8

# install PRIS and Orcale Java
RUN curl -fsSLO -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.rpm \
    && yum -y install jdk-8u112-linux-x64.rpm \
    && rm jdk-8u112-linux-x64.rpm \
    # install PRIS software
    && curl -fsSLO https://github.com/OpenNMS/opennms-provisioning-integration-server/releases/download/1.1.5/opennms-pris-dist-1.1.5-release-archive.tar.gz \
    && tar -xzvf opennms-pris-dist-1.1.5-release-archive.tar.gz -C /opt \
    && mv /opt/opennms-pris-dist-1.1.5 /opt/opennms-pris \
    && rm -f opennms-pris-dist-1.1.5-release-archive.tar.gz \
    # create directories for data
    && mkdir -p /data/init \
    && mkdir -p /data/export \
    && mkdir -p /data/container/initflags \
    && mv /opt/opennms-pris/requisitions /data/container \
    && ln -s /data/container/requisitions /opt/opennms-pris/requisitions \
    # cleanup for a smaller Docker image
    && yum -y clean all
 

# copy start script
COPY scripts/* /opt/containerscripts/

# run.sh
CMD ["/opt/containerscripts/run.sh"]
