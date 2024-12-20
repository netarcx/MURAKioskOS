FROM ubuntu:latest
LABEL maintainer="Trent 2129"

ENV RUNNING_IN_DOCKER=1

ENV APP_NAME="MURAFMSKioskOS"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  chromium \
  python3-pip \
  unclutter \
  xdotool
RUN apt-get install python3-pychrome

COPY src/modules/minimalkioskos/filesystem/home/pi/scripts/* /
COPY src/modules/minimalkioskos/filesystem/home/pi/scripts/startup.sh /startapp.sh

COPY src/modules/minimalkioskos/filesystem/boot/* /config/
