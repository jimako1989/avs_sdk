#!/bin/sh
THIS_SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONTAINER_LOGON_DIR=/root
docker run -v ${THIS_SCRIPT_DIR}/home:${CONTAINER_LOGON_DIR} -p 127.0.0.1:5900:5900 -p 127.0.0.1:5901:5901 -w ${CONTAINER_LOGON_DIR} -itd jimako1989/ubuntu-avs_sdk