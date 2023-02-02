FROM alpine:latest

RUN apk update && apk upgrade
##### SSH #####
RUN apk add --no-cache --update openssh
RUN mkdir /root/.ssh
RUN ssh-keygen -A

RUN sed -i 's/#PermitTunnel no/PermitTunnel yes/' /etc/ssh/sshd_config \
  && sed -i 's/AllowTcpForwarding no/AllowTcpForwarding yes/' /etc/ssh/sshd_config

##### VSCode #####
RUN apk add --no-cache --update bash curl wget nano git gcompat libstdc++ tar python3
RUN mkdir -p ~/.vscode-server/data/Machine/
RUN echo '{"git.path": "/usr/bin/git",}' > ~/.vscode-server/data/Machine/settings.json

##### Clean #####
RUN rm -rf /tmp/* /var/cache/apk/*

EXPOSE 22 5000 3000 8000 80 8080 443

VOLUME ['/root/.ssh/authorized_keys']

WORKDIR /app

ENTRYPOINT ["/usr/sbin/sshd"]
