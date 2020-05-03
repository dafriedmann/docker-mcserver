#! /bin/bash
echo "eula=$EULA" >> eula.txt

java -jar -Xmx1024M -Xms1024M -jar server.jar nogui