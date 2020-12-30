#!/bin/bash
#Copies all non existing confi files to the data folder


if [ "$(ls -A '/minecraft/conf')" ]; then
	cp -n /minecraft/conf/* .
fi

echo "eula=$EULA" >> eula.txt
java -jar -Xmx$MAX_MEMORY -Xms$MIN_MEMORY -jar /minecraft/server.jar nogui
