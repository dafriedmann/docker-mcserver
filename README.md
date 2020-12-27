# Docker Minecraft Server

![Docker Minecraft Server](https://raw.githubusercontent.com/dafriedmann/docker-mcserver/master/minecraft_docker.png)

Run minecraft vanilla server in a docker container.

## Get started - quick and easy
If you have not already, go ahead and [install docker-compose](https://docs.docker.com/compose/install/).
Example running image with volume for storing persistent data:

```
version: '3'
services:
    minecraft:
        image: dafriedmann/minecraft-server
        container_name: mcserver
        environment:
            - EULA=true
        ports:
            - 25565:25565
        volumes: 
            - mcserver-data:/minecraft/data

volumes:
    mcserver-data:
```

## Build a custom image yourself

In case you want to build an image yourself follow these instructions:

1. clone the repo
```
git clone https://github.com/dafriedmann/docker-mcserver.git
```
2. use docker-compose to build
```
docker-compose build
```
3. use docker-compose to start
```
docker-compose up -d
```

## Persistent data
In order to be able to upgrade the minecraft version while leaving the data (e.g. world) untouched
you can mount a volume to the server data path (see docker-compose.yml).

The data path in the container is:
``` /minecraft/data ```

## Edit Config files

To edit the config files (e.g. server.properties) one can mount them to `/minecraft/conf`. All files in this directory will copied to `/minecraft/data` if they aren't existing there. 

Alternatively use a sidecar and attach to the mcserver-data volume. First cd into the minecraft folder (where the docker-compose lives) and run one of the following commands.

This will spin up a sidecar to edit the server.properties.
Use ESC and :q to exit the sidecar which then destroys itself. 

```${PWD##*/}``` is used to get the current dir name. If you are not in the right dir or the volume is named differently you can replace the volume name.
In order to find out the volume ```docker volume list``` may be useful.

### Edit server.properties
```
docker run -it --rm -v ${PWD##*/}_mcserver-data:/minecraft busybox vi /minecraft/server.properties
```
### Edit whitelist.json
```
docker run -it --rm -v ${PWD##*/}_mcserver-data:/minecraft busybox vi /minecraft/whitelist.json
```

### Edit ops.json
```
docker run -it --rm -v ${PWD##*/}_mcserver-data:/minecraft busybox vi /minecraft/ops.json
```

**Note: If you changed something in the config you need to restart the mcserver.
Thus ```docker-compose restart``` can be used.**

## Increase memory limit
The default settings for -Xmx and -Xms are 1024m.
If you want to increase the memory simply override the following two environment variables.

example with 2048m:
```
MAX_MEMORY=2048m
MIN_MEMORY=2048m
```
When using docker-compose just add them as array elements to the 
environment section.

## Run with kubernetes

For an kubernetes example see: [Kubernetes Example]](.github/k8s-example.md)

---
Hint: To find a minecraft user id, one can use: https://namemc.com/