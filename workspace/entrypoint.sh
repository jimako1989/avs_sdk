#!/bin/sh
pulseaudio -D --exit-idle-time=-1
pacmd load-module module-pipe-source file=/dev/audio format=s16 rate=44100 channels=2
socat tcp-listen:3000 file:/dev/audio &
cd /root/sdk-folder/sdk-build && python AuthServer/AuthServer.py