FROM alpine:latest

ENV GIT_PATH=/usr/bin/git
ENV SSH_KEY=

RUN apk add --no-cache --update openrc openssh nano jq  && rm -rf /tmp/* /var/cache/apk/*
RUN apk add --no-cache --update gcompat libstdc++ wget curl bash && rm -rf /tmp/* /var/cache/apk/*

RUN mkdir -p ~/.vscode-server/data/Machine/

RUN mkdir -p /root/.ssh \
  && chmod 700 /root/.ssh \
  && echo $SSH_KEY > ~/.ssh/authorized_keys \
  && ssh-keygen -A \
  && mkdir -p /run/openrc \
  && touch /run/openrc/softlevel \
  && sed -i 's/#PermitTunnel no/PermitTunnel yes/' /etc/ssh/sshd_config \
  && sed -i 's/AllowTcpForwarding no/AllowTcpForwarding yes/' /etc/ssh/sshd_config

RUN jq --null-input --arg path "$GIT_PATH" '{"git.path": $path,}' > ~/.vscode-server/data/Machine/settings.json

RUN rc-status \
  && rc-update add sshd

COPY /data/* /

EXPOSE 22 5000 3000

WORKDIR /app

ENTRYPOINT ["sh", "/start.sh"]
