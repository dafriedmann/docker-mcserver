#!/bin/bash
cd /minecraft/data
echo "eula=$EULA" >> eula.txt
java -jar -Xmx1024M -Xms1024M -jar /minecraft/server.jar nogui