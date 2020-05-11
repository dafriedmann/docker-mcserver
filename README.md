# Docker Minecraft Server

![Docker Minecraft Server](minecraft_docker.png)

Run minecraft vanilla server in a docker container :whale:.

## Get started - quick and easy
A image can be found under docker hub: [dafriedmann/minecraft-server](https://hub.docker.com/r/dafriedmann/minecraft-server)
To spin up a server just follow the instructions provided under the dockerhub overview :).

## Build a custom image yourself

In case you want to build an image yourself follow these instructions:
If you have not already, go ahead and [install docker-compose](https://docs.docker.com/compose/install/).

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