#!/bin/sh
THIS_SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONTAINER_LOGON_DIR=/home/pi/workspace
echo "Host dir:"${THIS_SCRIPT_DIR}/workspace" Client dir:"${CONTAINER_LOGON_DIR}
docker run -v ${THIS_SCRIPT_DIR}/workspace:${CONTAINER_LOGON_DIR} -it jimako1989/avs_sdk