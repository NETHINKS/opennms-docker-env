FROM centos:7.3.1611
MAINTAINER NETHINKS GmbH <support@nethinks.com>

ARG build_locale=de_DE
ARG build_timezone=Europe/Berlin

# set locales
RUN localedef -c -i ${build_locale} -f UTF-8 ${build_locale}.utf-8 \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/${build_timezone} /etc/localtime

ENV LANG ${build_locale}.utf8

# install yourDashboard
RUN yum -y install httpd.x86_64 php.x86_64 php-common.x86_64 php-soap.x86_64 \
    # install yourDashboard software
    && curl -fsSLO https://github.com/michael-batz/yourDashboard/archive/yourdashboard-0.3.tar.gz \
    && tar -xzvf yourdashboard-0.3.tar.gz -C /opt \
    && mv /opt/yourDashboard-yourdashboard-0.3 /opt/yourdashboard \
    && rm -f yourdashboard-0.3.tar.gz \
    && ln -s /opt/yourdashboard/web/ /var/www/html/yourdashboard \
    # create directories for data
    && mkdir -p /data/init \
    && mkdir -p /data/export \
    && mkdir -p /data/container/initflags \
    && mv /opt/yourdashboard/etc /data/container \
    && ln -s /data/container/etc /opt/yourdashboard/etc \
    # cleanup for a smaller Docker image
    && yum -y clean all

# copy start script
COPY scripts/* /opt/containerscripts/

# run.sh
CMD ["/opt/containerscripts/run.sh"]
