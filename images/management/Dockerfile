FROM centos:7.4.1708
MAINTAINER NETHINKS GmbH <support@nethinks.com>

ARG build_locale=de_DE
ARG build_timezone=Europe/Berlin
ARG url_sw_docker=https://get.docker.com/builds/Linux/x86_64/docker-17.03.1-ce.tgz

# set locales
RUN localedef -c -i ${build_locale} -f UTF-8 ${build_locale}.utf-8 \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/${build_timezone} /etc/localtime

ENV LANG ${build_locale}.utf8

# install OpenSSH server, cron, software, scripts and docker client
RUN yum install -y openssh-server.x86_64 less.x86_64 net-snmp-utils.x86_64 bind-utils.x86_64 \
    telnet.x86_64 tcpdump.x86_64 openssl.x86_64 traceroute.x86_64 samba-client.x86_64 \
    openssh-clients.x86_64 ftp.x86_64 vim-enhanced.x86_64 cronie.x86_64 \
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' \
    && curl -fsSLo docker.tgz ${url_sw_docker} \
    && tar --strip-components=1 -xvzf docker.tgz -C /usr/local/bin \
    && rm /docker.tgz \
    && mkdir -p /data/container/etc \
    && mkdir -p /data/container/tmp \
    && mkdir -p /data/container/initflags \
    # default settings in sshd_config
    && sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config \
    # create cronjob for backup.sh
    && echo "0 21 * * *  root  /opt/managerscripts/backup.sh" >>  /etc/crontab \
    && echo "" >> /etc/crontab \
    # cleanup for a smaller Docker image
    && yum -y clean all

# copy scripts
COPY scripts/* /opt/containerscripts/
COPY managerscripts/* /opt/managerscripts/

# start SSH server
CMD ["/opt/containerscripts/run.sh"]
