# CrabSpace

Based on alpine with 36Mb 😁

> ⚠️ - I choose to not parse devcontainer, that can be easly did.
> explain at end.

## Usage

Here are some example snippets to help you get started creating a container.

```dockerfile
docker run -d \
  --name=crabspace \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Paris \
  -v :/app `#optional` \
  --restart unless-stopped \
  lscr.io/damienmillet/crabspace:latest
```

### PostInstall

```bash
# on your computer
cat .ssh/urkey.pub
# on the host
docker run -dit crabspace /bin/bash
# on the container
echo <urkey> >> ~/.ssh/authorized_keys
hostname -i
# on your computer
# add in ur .ssh/config
echo "Host <your_hostname>
  HostName <your_ip>
  User root
  Port 22
  IdentityFile ~/.ssh/urkey
  PreferredAuthentications publickey" >> ~/.ssh/config
```

## Parameters

| Parameter           | Function                                                     |
| ------------------- | ------------------------------------------------------------ |
| -e PUID=1000        | for UserID - see below for explanation                       |
| -e PGID=1000        | for GroupID - see below for explanation                      |
| -e TZ=Europe/London | Specify a timezone to use EG Europe/London, this is required for Date |
| -v /app             | Location of your app on disk                                 |


To use ~codespace free : 
- install docker  
- [vscode docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) 
- [dev containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

That's all !

Now u can create devcontainer easly !

For docker wremote host : 

```shell
docker create context $NAME  --docker "host=ssh://$HOST"
docker use remote $NAME
```

issues : 
docker: command not found => create symbolic link on the server to add docker to /bin






