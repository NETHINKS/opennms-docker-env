FROM centos:7.3.1611
MAINTAINER NETHINKS GmbH <support@nethinks.com>

ARG build_locale=de_DE
ARG build_timezone=Europe/Berlin

# set locales
RUN localedef -c -i ${build_locale} -f UTF-8 ${build_locale}.utf-8 \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/${build_timezone} /etc/localtime

ENV LANG ${build_locale}.utf8

# install AlarmForwarder
RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm \
    && yum -y install python35u.x86_64 python35u-pip.noarch python35u-devel.x86_64 \
        postgresql.x86_64 postgresql-devel.x86_64 gcc psmisc.x86_64 \
    # install Python 3.5 modules
    && pip3.5 install requests ldap3 gunicorn flask sqlalchemy psycopg2 \
    && ln -s /usr/bin/python3.5 /usr/bin/python3 \
    # install AlarmForwarder software
    && curl -fsSLO https://github.com/NETHINKS/opennms_alarmforwarder/archive/1.0.1.tar.gz \
    && tar -xzvf 1.0.1.tar.gz -C /opt \
    && mv /opt/opennms_alarmforwarder-1.0.1 /opt/opennms_alarmforwarder \
    && rm -f 1.0.1.tar.gz \
    # create directories for data
    && mkdir -p /data/init \
    && mkdir -p /data/export \
    && mkdir -p /data/container/initflags \
    && mv /opt/opennms_alarmforwarder/etc /data/container \
    && mv /opt/opennms_alarmforwarder/logs /data/container \
    && ln -s /data/container/etc /opt/opennms_alarmforwarder/etc \
    && ln -s /data/container/logs /opt/opennms_alarmforwarder/logs \
    # cleanup for a smaller Docker image
    && yum -y clean all

# copy start script
COPY scripts/* /opt/containerscripts/

# run.sh
CMD ["/opt/containerscripts/run.sh"]
