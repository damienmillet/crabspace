#!/bin/sh
echo $SSH_KEY > ~/.ssh/authorized_keys
jq --null-input --arg path "$GIT_PATH" '{"git.path": $path,}' > ~/.vscode-server/data/Machine/settings.json
rc-service sshd start
echo "Starting VSCode Server"
echo "You can now connect to this container"
echo "if a token wasn't given, you can must add the generated token to your github account"

/bin/sh
