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

## Increase memory limit
The default settings for -Xmx and -Xms is 1024m.
If you want to increase the memory simply override the following two environment variables.

example with 2048m:
```
MAX_MEMORY=2048m
MIN_MEMORY=2048m
```
When using docker-compose just add them as array elements to the 
environment section.