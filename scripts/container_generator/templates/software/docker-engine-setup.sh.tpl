# docker-engine setup
tar --strip-components=1 -xvzf software/docker-engine/docker-engine.tar.gz \
    -C /usr/local/bin

# create group docker
groupadd docker

# install bash completion
tar --strip-components=3 -xvzf software/docker-engine/docker-engine.tar.gz \
    -C /etc/bash_completion.d/ docker/completion/bash/docker

# install systemd socket
cat > /etc/systemd/system/docker.socket <<eof
{% include 'templates/software/docker.socket.tpl' %}
eof

# install systemd socket
cat > /etc/systemd/system/docker.service <<eof
{% include 'templates/software/docker.service.tpl' %}
eof

# reload systemd config and enable service
systemctl daemon-reload
systemctl enable docker.service
systemctl start docker.service
