FROM centos:7.3.1611
MAINTAINER NETHINKS GmbH <support@nethinks.com>

ARG build_locale=de_DE
ARG build_timezone=Europe/Berlin

# set locales
RUN localedef -c -i ${build_locale} -f UTF-8 ${build_locale}.utf-8 \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/${build_timezone} /etc/localtime

ENV LANG ${build_locale}.utf8

# install Apache Cassandra and Oracle Java
RUN curl -fsSLO -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.rpm \
    && yum -y install jdk-8u112-linux-x64.rpm \
    && rm -f jdk-8u112-linux-x64.rpm \
    && yum -y install psmisc.x86_64 \
    # install Apache Cassandra
    && curl -fsSLO http://www-eu.apache.org/dist/cassandra/3.9/apache-cassandra-3.9-bin.tar.gz \
    && tar -xzvf apache-cassandra-3.9-bin.tar.gz -C /opt \
    && mv /opt/apache-cassandra-3.9 /opt/cassandra \
    && rm -Rf /opt/cassandra/javadoc \
    && rm -f apache-cassandra-3.9-bin.tar.gz \
    # create directories for data
    && mkdir -p /data/init \
    && mkdir -p /data/export \
    && mkdir -p /data/container/initflags \
    && mkdir -p /data/container/cassandra \
    && mkdir -p /data/container/cassandra/data \
    && mkdir -p /data/container/cassandra/logs \
    && mv /opt/cassandra/conf /data/container/cassandra/ \
    && ln -s /data/container/cassandra/data /opt/cassandra/data \
    && ln -s /data/container/cassandra/conf /opt/cassandra/conf \
    && ln -s /data/container/cassandra/logs /opt/cassandra/logs \
    # create user cassandra
    && adduser --system --home /opt/cassandra cassandra \
    && chown -R -L cassandra:cassandra /opt/cassandra \
    # cleanup for a smaller Docker image
    && yum -y clean all


# copy start script
COPY scripts/* /opt/containerscripts/

# run.sh
CMD ["/opt/containerscripts/run.sh"]
