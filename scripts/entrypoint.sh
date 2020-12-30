#!/bin/bash
#cd /minecraft/data
#Copies all non existing confi files to the data folder

# Check if directory exists and if files are present
if ! ls -1qA $DIR | grep -q . ; then
        echo "Copying files from /minecraft/conf/ ..."
        cp -n /minecraft/conf/* .
fi

echo "eula=$EULA" >> eula.txt
java -jar -Xmx$MAX_MEMORY -Xms$MIN_MEMORY -jar /minecraft/server.jar nogui
