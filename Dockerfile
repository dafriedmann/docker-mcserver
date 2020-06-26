FROM openjdk:11-jre-slim
LABEL maintainer="docker@dfriedmann.de"

ENV EULA false
ENV MAX_MEMORY 1024m
ENV MIN_MEMORY 1024m

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
ADD --chown=minecraft:minecraft https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar .
COPY --chown=minecraft:minecraft /scripts/entrypoint.sh .

# Start
EXPOSE 25565
ENTRYPOINT ["./entrypoint.sh"]


