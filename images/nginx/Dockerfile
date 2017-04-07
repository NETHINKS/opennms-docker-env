FROM centos:7.3.1611
MAINTAINER NETHINKS GmbH <support@nethinks.com>

ARG build_locale=de_DE
ARG build_timezone=Europe/Berlin

# set locales
RUN localedef -c -i ${build_locale} -f UTF-8 ${build_locale}.utf-8 \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/${build_timezone} /etc/localtime

ENV LANG ${build_locale}.utf8

# copy nginx repo definition
COPY files/nginx.repo /etc/yum.repos.d/

RUN yum -y install nginx-1.10.2-1.el7.ngx \
    # create directories and links
    && mkdir -p /data/init \
    && mkdir -p /data/export \
    && mkdir -p /data/container \
    && mkdir -p /data/container/www \
    && mkdir -p /data/container/initflags \
    && mv /etc/nginx /data/container/etc \
    && mv /var/log/nginx /data/container/logs \
    && ln -s /data/container/etc /etc/nginx \
    && ln -s /data/container/logs /var/log/nginx \
    # cleanup for a smaller Docker image
    && yum -y clean all
 

# copy start script
COPY scripts/* /opt/containerscripts/

# run.sh
CMD ["/opt/containerscripts/run.sh"]
