FROM ubuntu:latest
LABEL maintainer="Trent 2129"

ENV RUNNING_IN_DOCKER=1

ENV APP_NAME="MURAFMSKioskOS-flatpak"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  sudo \
  python3-pip \
  unclutter \
  xdotool \
  nano \
  curl \
  flatpak

RUN apt-get clean

RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

RUN flatpak install -y flathub io.github.ungoogled_software.ungoogled_chromium

RUN pip3 install pychrome --break-system-packages

COPY src/modules/minimalkioskos/filesystem/home/pi/scripts/* /
COPY src/modules/minimalkioskos/filesystem/home/pi/scripts/startup.sh /startapp.sh

COPY src/modules/minimalkioskos/filesystem/boot/* /config/
