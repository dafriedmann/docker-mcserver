FROM openjdk:11-jre-slim
LABEL maintainer="docker@dfriedmann.de"

ARG SERVER_URL=https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar

ENV EULA false
ENV MAX_MEMORY 1024m
ENV MIN_MEMORY 1024m

# Add minecraft user
# Image uses /minecraft for storing the server.jar
# and /minecraft/data for persistent data
# /etc/minecraft is used for configuration files like server.properties or whitelist.json. 
# All files from this directory will copied to /minecraft/data if they don't alread exist.
# This allows the user of this image to mount configuration files which still can be modified by minecraft like the whitelist.json
RUN groupadd -g 1001 minecraft && \
    useradd -u 1001 -g minecraft minecraft && \
    mkdir /minecraft && \
    mkdir /minecraft/data && \
    mkdir /etc/minecraft && \
    chown -R 1001:1001 /minecraft && \
    chown -R 1001:1001 /etc/minecraft

USER minecraft
WORKDIR /minecraft

# Download Minecraft and add entrypoint
ADD --chown=minecraft:minecraft $SERVER_URL .
COPY --chown=minecraft:minecraft /scripts/entrypoint.sh .

# Start
EXPOSE 25565
ENTRYPOINT ["./entrypoint.sh"]


