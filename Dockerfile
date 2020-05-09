FROM openjdk:11-jre-slim
LABEL maintainer="docker@dfriedmann.de"

ENV EULA false

# Add minecraft user
# Image uses /minecraft for storing the server.jar
# and /minecraft/data for persistent data
RUN groupadd -g 1001 minecraft && \
    useradd -u 1001 -g minecraft minecraft && \
    mkdir /minecraft && \
    mkdir /minecraft/data && \
    chown -R 1001:1001 /minecraft

USER minecraft
WORKDIR /minecraft

# Download Minecraft and add entrypoint
ADD --chown=minecraft:minecraft https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar .
COPY --chown=minecraft:minecraft /scripts/entrypoint.sh .

# Start
EXPOSE 25565
ENTRYPOINT ["./entrypoint.sh"]


