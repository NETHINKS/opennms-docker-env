FROM centos:7.4.1708
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

# copy start scripts
COPY scripts/ /opt/containerscripts/

RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm \
    # install required software
    && yum -y install nginx-1.10.2-1.el7.ngx \
                python35u.x86_64 python35u-pip.noarch python35u-devel.x86_64 \
                gcc.x86_64 openssl-devel.x86_64 \
    # install Python3.5 environment
    && pip3.5 install Jinja2==2.9.6 pyOpenSSL==17.0.0 \
    && ln -s /usr/bin/python3.5 /usr/bin/python3 \
    # create directories and links
    && mkdir -p /data/init \
    && mkdir -p /data/export \
    && mkdir -p /data/container \
    && mkdir -p /data/container/ssl \
    && mkdir -p /data/container/initflags \
    && mkdir -p /opt/www/start \
    && mv /var/log/nginx /data/container/logs \
    && ln -s /data/container/logs /var/log/nginx \
    && cp -R /opt/containerscripts/nginx/static/start/* /opt/www/start \
    # cleanup for a smaller Docker image
    && yum -y clean all
 


# run.sh
CMD ["/opt/containerscripts/run.sh"]
