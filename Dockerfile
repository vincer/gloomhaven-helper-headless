FROM openjdk:14.0.2-slim-buster

RUN apt-get update
RUN apt-get install --yes wget unzip xvfb liblwjgl-java tini

# Version of Gloomhaven Helper to use, passed in as a build arg.
# Latest version can be gleaned from http://esotericsoftware.com/gloomhaven-helper
# e.g. 8.4.6 (no leading 'v')
# GitHub Action set up to auto-fetch the latest version and build it.
ARG version

RUN wget http://esotericsoftware.com/files/ghh/GloomhavenHelper-$version.zip
RUN unzip GloomhavenHelper-$version.zip

COPY entrypoint.sh .

ENTRYPOINT ["/usr/bin/tini", "--", "./entrypoint.sh"]

EXPOSE 58887/udp
EXPOSE 58888/tcp
