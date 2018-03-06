#!/bin/sh
THIS_SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONTAINER_LOGON_DIR=/root
docker run -p 6080:80 -it -v ${THIS_SCRIPT_DIR}/home:${CONTAINER_LOGON_DIR} jimako1989/ubuntu-avs_sdk