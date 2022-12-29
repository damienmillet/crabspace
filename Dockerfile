FROM alpine:latest

ENV SSH_KEY=
ARG EMAIL=

RUN apk add --no-cache --update openrc openssh nano && rm -rf /tmp/* /var/cache/apk/*
RUN apk add --no-cache --update gcompat libstdc++ wget curl bash git && rm -rf /tmp/* /var/cache/apk/*

RUN mkdir -p /root/.ssh \
  && chmod 700 /root/.ssh \
  && echo $SSH_KEY > ~/.ssh/authorized_keys \
  && ssh-keygen -A \
  && openrc && touch /run/openrc/softlevel && openrc \
  && sed -i 's/#PermitTunnel no/PermitTunnel yes/' /etc/ssh/sshd_config \
  && sed -i 's/AllowTcpForwarding no/AllowTcpForwarding yes/' /etc/ssh/sshd_config \ 
  && rc-update add sshd

RUN mkdir -p ~/.vscode-server/data/Machine/ \
  && echo '{"git.path": "/usr/bin/git",}' > ~/.vscode-server/data/Machine/settings.json \
  && ssh-keygen -t rsa  -b 4096 -C ${EMAIL} -f ~/.ssh/id_rsa -q -N ""

COPY /data/* /

EXPOSE 22 5000 3000 8000 80 8080 443

WORKDIR /app

ENTRYPOINT ["sh", "/bin/sh"]
