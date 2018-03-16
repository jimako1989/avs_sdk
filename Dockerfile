FROM jsurf/rpi-raspbian
MAINTAINER jimako1989
USER root

WORKDIR /home/root
ENV HOME /home/root

RUN [ "cross-build-start" ]

# The first step is to make sure your machine has the latest package lists and then install the latest version of each package in that list:
RUN apt-get update \
 && apt-get upgrade -y
# Now, let's set up our tool:
RUN apt-get install -y wget
RUN wget https://raw.githubusercontent.com/alexa/avs-device-sdk/master/tools/Install/setup.sh && wget https://raw.githubusercontent.com/alexa/avs-device-sdk/master/tools/Install/config.txt && wget https://raw.githubusercontent.com/alexa/avs-device-sdk/master/tools/Install/pi.sh
RUN [ "cross-build-end" ]
CMD cp /home/root/workspace/config.txt /home/root/ \
CMD sudo bash setup.sh config.txt
CMD sudo bash startauth.sh
CMD sudo bash startsample.sh