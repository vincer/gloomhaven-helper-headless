FROM openjdk:14-slim-buster

RUN apt-get update
RUN apt-get install --yes wget unzip xvfb liblwjgl-java tini

ARG version=8.4.4

RUN wget http://esotericsoftware.com/files/ghh/GloomhavenHelper-$version.zip
RUN unzip GloomhavenHelper-$version.zip

COPY entrypoint.sh .

ENTRYPOINT ["/usr/bin/tini", "--", "./entrypoint.sh"]

EXPOSE 58887/udp
EXPOSE 58888/tcp
