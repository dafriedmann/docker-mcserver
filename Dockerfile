FROM openjdk:11-jre-slim
LABEL maintainer="docker@dfriedmann.de"

ENV EULA false
ENV MAX_MEMORY 1024m
ENV MIN_MEMORY 1024m
ENV SERVER_DOWNLOAD_URL https://launcher.mojang.com/v1/objects/f02f4473dbf152c23d7d484952121db0b36698cb/server.jar

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
ADD --chown=minecraft:minecraft $SERVER_DOWNLOAD_URL .
COPY --chown=minecraft:minecraft /scripts/entrypoint.sh .

# Start
EXPOSE 25565
ENTRYPOINT ["./entrypoint.sh"]


