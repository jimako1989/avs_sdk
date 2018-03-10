#!/bin/sh
cp /home/root/workspace/AlexaClientSDKConfig.json /home/root/sdk-folder/sdk-build/Integration/
cd /home/root/sdk-folder/sdk-build && python AuthServer/AuthServer.py