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

To edit the config files (e.g. server.properties) one can mount them to `/etc/minecraft`. All files in this directory will copied to `/minecraft/data` if they aren't existing there. 

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

To use this image with kubernetes, one can use this:
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: minecraft
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: minecraft-data-claim
  namespace: minecraft
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 10Gi
  storageClassName: local-path
---
apiVersion: v1
kind: Service
metadata:
  name: minecraft
  namespace: minecraft
spec:
  type: NodePort
  ports:
    - name: minecraft
      port: 25565
      targetPort: 25565
      nodePort: 30565
      protocol: TCP

  selector:
    app: minecraft
---
kind: Deployment
apiVersion: apps/v1
metadata:
  namespace: minecraft
  name: minecraft
  labels:
    app: minecraft
spec:
  replicas: 1
  selector:
    matchLabels:
      app: minecraft
  template:
    metadata:
      labels:
        app: minecraft
    spec:
      containers:
        - name: minecraft
          image: dafriedmann/minecraft-server
          imagePullPolicy: Always
          ports:
            - name: minecraft
              containerPort: 25565
              protocol: TCP
          env:
            - name: EULA
              value: "true"
          volumeMounts:
            - name: minecraft-data
              mountPath: /minecraft/data:rw
            - name: minecraft-config
              mountPath: /etc/minecraft
      volumes:
        - name: minecraft-data
          persistentVolumeClaim:
            claimName: minecraft-data-claim
        - name: minecraft-config
          configMap:
            name: minecraft-config
      securityContext: 
        runAsUser: 1001 
        runAsGroup: 1001
        fsGroup: 1001
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: minecraft-config
  namespace: minecraft
data:
  server.properties: |
    #Minecraft server properties
    view-distance=10
    max-build-height=256
    server-ip=
    level-seed=
    gamemode=0
    server-port=25565
    enable-command-block=false
    allow-nether=true
    enable-rcon=false
    op-permission-level=3
    enable-query=false
    prevent-proxy-connections=false
    generator-settings=
    resource-pack=
    player-idle-timeout=0
    level-name=world
    motd= A Minecraft Server running on K8s
    force-gamemode=false
    hardcore=false
    white-list=true
    broadcast-console-to-ops=true
    pvp=true
    spawn-npcs=true
    generate-structures=true
    spawn-animals=true
    snooper-enabled=true
    difficulty=2
    network-compression-threshold=256
    level-type=DEFAULT
    spawn-monsters=true
    max-tick-time=60000
    max-players=20
    enforce-whitelist=true
    resource-pack-sha1=
    online-mode=true
    allow-flight=true
    max-world-size=29999984
    function-permission-level=2
    rate-limit=0
  whitelist.json: |
    [
    {
      "uuid": "YOUR-USER-ID",
      "name": "YourUserName"
    }
    ]
  ops.json: |
    [
    {
      "uuid": "YOUR-USER-ID",
      "name": "YourUserName",
      "level": 4
    }
    ]
```

Hint: To find a minecraft user id, one can use: https://namemc.com/