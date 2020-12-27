# Run with kubernetes

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
              mountPath: /minecraft/conf
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
