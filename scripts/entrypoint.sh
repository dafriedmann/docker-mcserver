#!/bin/bash
cd /minecraft/data
#Copies all non existing confi files to the data folder
cp -n /etc/minecraft/* .
echo "eula=$EULA" >> eula.txt
java -jar -Xmx$MAX_MEMORY -Xms$MIN_MEMORY -jar /minecraft/server.jar nogui