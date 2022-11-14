#!/bin/sh
echo $SSH_KEY > ~/.ssh/authorized_keys
jq --null-input --arg path "$GIT_PATH" '{"git.path": $path,}' > ~/.vscode-server/data/Machine/settings.json
rc-service sshd start
echo "Starting VSCode Server"
echo "You can now connect to this container"
echo "first ssh connection can be needed for fingerprint"

/bin/sh
