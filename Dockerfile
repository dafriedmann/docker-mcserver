FROM openjdk:11-jre-slim

WORKDIR /opt/minecraft

RUN apt update && apt install curl -y

ENV EULA false

# Download Minecraft
RUN curl https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar -o server.jar

# Add entrypoint
ADD entrypoint.sh .

# Start
EXPOSE 25565
CMD ["./entrypoint.sh"]