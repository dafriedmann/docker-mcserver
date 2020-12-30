#!/bin/bash

# Check if directory exists and if files are present
if ls -1qA  /minecraft/data | grep -q . ; then
        echo "Copying files from /minecraft/conf/ to /minecraft/conf"
        # Copy all not already existing config files to the main folder
        cp -n /minecraft/conf/* /minecraft/data
else
        echo "Skip copying files..."
fi

cd /minecraft/data
echo "eula=$EULA" >> eula.txt
java -jar -Xmx$MAX_MEMORY -Xms$MIN_MEMORY -jar /minecraft/server.jar nogui

