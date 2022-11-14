FROM alpine:latest

ENV SSH_KEY=

RUN apk add --no-cache --update openrc openssh nano && rm -rf /tmp/* /var/cache/apk/*
RUN apk add --no-cache --update gcompat libstdc++ wget curl bash git && rm -rf /tmp/* /var/cache/apk/*

RUN mkdir -p ~/.vscode-server/data/Machine/

RUN mkdir -p /root/.ssh \
  && chmod 700 /root/.ssh \
  && echo $SSH_KEY > ~/.ssh/authorized_keys \
  && ssh-keygen -A \
  && mkdir -p /run/openrc \
  && touch /run/openrc/softlevel \
  && sed -i 's/#PermitTunnel no/PermitTunnel yes/' /etc/ssh/sshd_config \
  && sed -i 's/AllowTcpForwarding no/AllowTcpForwarding yes/' /etc/ssh/sshd_config
  
RUN echo '{"git.path": "/usr/bin/git",}' > ~/.vscode-server/data/Machine/settings.json

RUN rc-status \
  && rc-update add sshd

COPY /data/* /

EXPOSE 22 5000 3000 8000 80 8080 443

WORKDIR /app

ENTRYPOINT ["sh", "/start.sh"]
