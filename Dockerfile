FROM alpine:latest

ENV SSH_KEY =
ENV SECURE = true

RUN apk update && apk upgrade
##### OpenRC #####
RUN apk add --no-cache --update openrc && openrc && touch /run/openrc/softlevel && openrc
##### SSH #####
RUN apk add --no-cache --update openssh 
# modifier le fichier /etc/ssh/sshd_config pour activer l'auth par root
RUN sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config \
  && sed -i 's/#PermitTunnel no/PermitTunnel yes/' /etc/ssh/sshd_config \
  && sed -i 's/AllowTcpForwarding no/AllowTcpForwarding yes/' /etc/ssh/sshd_config
# check if SECURE is true
RUN if [ ${SECURE} = true ]; then \
  && sed -i "s/#PermitEmptyPasswords no/PermitEmptyPasswords yes/g" /etc/ssh/sshd_config:

RUN mkdir -p /root/.ssh
RUN echo $SSH_KEY > ~/.ssh/authorized_keys
# remove root password
RUN passwd -d root
RUN rc-update add sshd default
RUN rc-service sshd start
# show ip for connection
RUN echo "ssh is open at : "
RUN hostname -i

##### VSCode #####  glib libc6-compat alpine-sdk  util-linux-misc procps
RUN apk add --no-cache --update bash curl wget nano git gcompat libstdc++ tar python3
RUN mkdir -p ~/.vscode-server/data/Machine/
RUN echo '{"git.path": "/usr/bin/git",}' > ~/.vscode-server/data/Machine/settings.json

##### Clean #####libgcc
RUN rm -rf /tmp/* /var/cache/apk/*

EXPOSE 22 5000 3000 8000 80 8080 443

WORKDIR /app

ENTRYPOINT ["/bin/sh"]
