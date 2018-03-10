#!/bin/sh
THIS_SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONTAINER_LOGON_DIR=/home/root/workspace
echo "Host dir:"${THIS_SCRIPT_DIR}/workspace" Client dir:"${CONTAINER_LOGON_DIR}
docker run -v ${THIS_SCRIPT_DIR}/workspace:${CONTAINER_LOGON_DIR} -it jimako1989/avs_sdk /bin/bash cd /home/root/sdk-folder/sdk-build/SampleApp/src && TZ=UTC ./SampleApp /home/root/sdk-folder/sdk-build/Integration/AlexaClientSDKConfig.json /home/root/sdk-folder/third-party/alexa-rpi/models