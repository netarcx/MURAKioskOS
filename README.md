# MURAFMS Kiosk Display
[![Build Status](https://travis-ci.org/TheLastProject/minimalKioskOS.svg?branch=master)](https://travis-ci.org/TheLastProject/minimalKioskOS)


A Dockerfile is also available, for running minimalKioskOS outside of a Raspberry Pi.

In comparison, FullPageOS runs Lighttpd, keeps the default pi:raspberry username:password combination, has SSH and X11VNC set up.

## How to use it?

*In most cases, you will probably want the continuous build, as this is rebuild once a month using a Travis cron and will contain the latest security patches released for Raspbian. However, it has not been tested. If you are more concerned with proper testing than security patches, use a stable release.*

1. Download a build from the releases tab on GitHub
2. Unzip
3. Install it [like any other Raspberry Pi image](https://www.raspberrypi.org/documentation/installation/installing-images/README.md)
4. Configure it

## Configuration settings
minimalKioskPresenter uses files in /boot for basic configuration:

- /boot/autosecure: If this file exists, automatically generate a random long password for the pi account to prevent access (default)
- /boot/mutesound.txt: Mute sound after page load for the given amount of seconds. 0 never mutes, -1 mutes forever (default: 0)
- /boot/spamkey.txt: Constantly spam this (list of) keys to Chromium, format like the key list in urls.txt (bind to this key in the JavaScript of your webpage to ensure things are correct, such as fullscreening a video)
- /boot/ssh: If this file exists, allow SSH access (make sure to remove autosecure and set a safe password yourself)
- /boot/urls.txt: Set the URLs to display, see below

### urls.txt

This file has the following format:
`url list-of-keys-to-send-after-page-load seconds-to-display`

If you want to display the page forever, use -1 for seconds.

Examples:

```
example.com -1
```

```
example.com/dashboard key:Tab type:username key:Tab type:password key:Return 60
example.com/logout 1
```

minimalKioskOS will wait for 1 second between each typing action. This time is added to the display time. To add extra delays, add statements like "sleep:5" (to sleep 5 seconds)

## Building minimalKioskOS (to run on Raspberry Pi)
This will create an .img file in the workspace directory

```
sudo apt-get install realpath p7zip-full qemu-user-static

git clone https://github.com/guysoft/CustomPiOS.git
git clone https://github.com/TheLastProject/minimalKioskOS.git
cd minimalKioskOS/src/image
wget -c 'https://downloads.raspberrypi.org/raspbian_lite_latest' -O 'latest-raspbian.zip'
cd ..
../../CustomPiOS/src/update-custompios-paths
sudo modprobe loop
sudo bash -x ./build_dist
```

## Docker image
First, ensure everything in `src/modules/minimalkioskos/filesystem/boot` is set to values you want.

Build a container: `docker build .`
Run the container: `docker run --rm -p 5800:5800 -p 5900:5900 --security-opt seccomp=unconfined <container_id>`

You can now view the content in a browser on port 5800 or a VNC client on port 5900.

See https://github.com/jlesage/docker-baseimage-gui for more options.
