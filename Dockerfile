FROM resin/armv7hf-debian-qemu
MAINTAINER jimako1989
USER root

WORKDIR /home/root
ENV HOME /home/root

# The first step is to make sure your machine has the latest package lists and then install the latest version of each package in that list:
RUN apt-get update && apt-get upgrade -y
# We need somewhere to put everything, so let's create some folders. This guide presumes that everything is built in ${HOME}, which we will presume is your home directory. If you choose to use different folder names, please update the commands throughout this guide accordingly:
RUN cd /home/root/ \
 && mkdir sdk-folder \
 && cd sdk-folder \
 && mkdir sdk-build sdk-source third-party application-necessities \
 && cd application-necessities \
 && mkdir sound-files
# Now, let's set up our toolchain:
RUN apt-get -y install git gcc build-essential libsqlite3-dev libcurl4-openssl-dev libfaad-dev libsoup2.4-dev libgcrypt20-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-good libasound2-dev doxygen wget python-setuptools libgtest-dev
# Installing latest cmake
RUN cd /home/root/sdk-folder/third-party \
 && wget https://cmake.org/files/v3.10/cmake-3.10.2.tar.gz \
 && tar -zxvf cmake-3.10.2.tar.gz \
 && cd cmake-3.10.2 \
 && ./configure \
 && make \
 && make install
# Next, PortAudio is required to record microphone data. Run this command to install and configure PortAudio:
RUN cd /home/root/sdk-folder/third-party \
 && wget -c http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz \
 && tar zxf pa_stable_v190600_20161030.tgz \
 && cd portaudio \
 && ./configure --without-jack \
 && make
# commentjson is required to parse comments in AlexaClientSDKConfig.json. Run this command to install commentjson:
RUN easy_install pip \
 && pip install --upgrade pip \
 && pip install commentjson
# Clone the AVS Device SDK and the Sensory wake word engine
RUN cd /home/root/sdk-folder/sdk-source \
 && git clone git://github.com/alexa/avs-device-sdk.git
# Next, let's clone the sensory wake word engine into our third-party directory:
RUN cd /home/root/sdk-folder/third-party \
 && git clone git://github.com/Sensory/alexa-rpi.git
# Now let's run the licensing script and accept the licensing agreement. This is required to use Sensory's wake word engine:
RUN cd /home/root/sdk-folder/third-party/alexa-rpi/bin/ \
 && yes | ./license.sh
# Run cmake to generate the build dependencies. This command declares that the wake word engine and gstreamer are enabled, and provides paths to the wake word engine and PortAudio:
RUN cd /home/root/sdk-folder/sdk-build \
 && cmake /home/root/sdk-folder/sdk-source/avs-device-sdk -DSENSORY_KEY_WORD_DETECTOR=ON -DSENSORY_KEY_WORD_DETECTOR_LIB_PATH=/home/root/sdk-folder/third-party/alexa-rpi/lib/libsnsr.a -DSENSORY_KEY_WORD_DETECTOR_INCLUDE_DIR=/home/root/sdk-folder/third-party/alexa-rpi/include -DGSTREAMER_MEDIA_PLAYER=ON -DPORTAUDIO=ON -DPORTAUDIO_LIB_PATH=/home/root/sdk-folder/third-party/portaudio/lib/.libs/libportaudio.a -DPORTAUDIO_INCLUDE_DIR=/home/root/sdk-folder/third-party/portaudio/include