FROM centos:7.3.1611
MAINTAINER NETHINKS GmbH <support@nethinks.com>

ARG build_locale=de_DE
ARG build_timezone=Europe/Berlin

# set locales
RUN localedef -c -i ${build_locale} -f UTF-8 ${build_locale}.utf-8 \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/${build_timezone} /etc/localtime

ENV LANG ${build_locale}.utf8

# install required software
RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm \
    && yum install -y openssh-server.x86_64 openssh-clients.x86_64 \
       python35u.x86_64 python35u-pip.noarch python35u-devel.x86_64 gcc.x86_64 openssl-devel.x86_64 \
    # install Python 3.5 modules
    && pip3.5 install requests jinja2 PyYAML pyOpenSSL \
    && ln -s /usr/bin/python3.5 /usr/bin/python3 \
    # configure SSH server
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' \
    && sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config \
    # install docker client
    && curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.03.1-ce.tgz \
    && tar --strip-components=1 -xvzf docker-17.03.1-ce.tgz -C /usr/local/bin \
    && rm /docker-17.03.1-ce.tgz \
    # install container_generator
    && curl -L https://api.github.com/repos/NETHINKS/opennms-docker-env/tarball > repo.tar.gz \
    && tar -xzvf repo.tar.gz -C /opt \
    && mv /opt/NETHINKS-opennms-docker-env* /opt/opennms-docker-env \
    && rm repo.tar.gz \
    # cleanup for a smaller Docker image
    && yum -y clean all

# copy scripts
COPY scripts/* /opt/containerscripts/

# start SSH server
CMD ["/opt/containerscripts/run.sh"]
