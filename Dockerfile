FROM openjdk:11-jre-slim
LABEL maintainer="docker@dfriedmann.de"

ENV EULA false

# Add minecraft user
RUN groupadd -g 1001 minecraft && \
    useradd -u 1001 -g minecraft minecraft
RUN mkdir -p /minecraft
RUN chown -R 1001:1001 /minecraft

USER minecraft

VOLUME ["/minecraft"]
WORKDIR /minecraft

# Download Minecraft and add entrypoint
ADD --chown=minecraft:minecraft https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar .
COPY --chown=minecraft:minecraft /scripts/entrypoint.sh .

# Start
EXPOSE 25565
ENTRYPOINT ["./entrypoint.sh"]


