FROM ubuntu:latest
LABEL maintainer="Trent 2129"

ENV RUNNING_IN_DOCKER=1

ENV APP_NAME="MURAFMSKioskOS"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  chromium \
  python3-pip \
  unclutter \
  xdotool \
  nano

RUN curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb 

RUN pip3 install pychrome --break-system-packages

COPY src/modules/minimalkioskos/filesystem/home/pi/scripts/* /
COPY src/modules/minimalkioskos/filesystem/home/pi/scripts/startup.sh /startapp.sh

COPY src/modules/minimalkioskos/filesystem/boot/* /config/
