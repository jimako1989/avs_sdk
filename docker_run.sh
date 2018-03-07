#!/bin/sh
THIS_SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONTAINER_LOGON_DIR=/root/workspace
echo "Host dir:"${THIS_SCRIPT_DIR}/workspace" Client dir:"${CONTAINER_LOGON_DIR}
echo "Launching the server... This may take a few minutes.."
chmod +x ${THIS_SCRIPT_DIR}/workspace/entrypoint.sh
docker run -v ${THIS_SCRIPT_DIR}/workspace:${CONTAINER_LOGON_DIR} -p 6080:80 -it jimako1989/ubuntu-avs_sdk