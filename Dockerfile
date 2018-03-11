FROM resin/armv7hf-debian-qemu
MAINTAINER jimako1989
USER root

WORKDIR /home/root
ENV HOME /home/root

RUN [ "cross-build-start" ]

# The first step is to make sure your machine has the latest package lists and then install the latest version of each package in that list:
RUN apt-get update
RUN apt-get upgrade -y
# Now, let's set up our toolchain:
RUN apt-get -y install git
RUN apt-get -y install gcc
RUN apt-get -y install cmake
RUN apt-get -y install build-essential
RUN apt-get -y install libsqlite3-dev
RUN apt-get -y install libcurl4-openssl-dev
RUN apt-get -y install libfaad-dev
RUN apt-get -y install libsoup2.4-dev
RUN apt-get -y install libgcrypt20-dev
RUN apt-get -y install libgstreamer-plugins-bad1.0-dev
RUN apt-get -y install gstreamer1.0-plugins-good
RUN apt-get -y install libasound2-dev
RUN apt-get -y install doxygen
RUN apt-get -y install wget
RUN apt-get -y install python-setuptools
RUN apt-get -y install libgtest-dev
RUN apt-get -y install libncurses5-dev
RUN apt-get -y install librhash-dev
# Installing latest cmake
RUN cd /home/root/sdk-folder/third-party \
 && wget https://cmake.org/files/v3.10/cmake-3.10.2.tar.gz
RUN tar -zxvf cmake-3.10.2.tar.gz
RUN cd cmake-3.10.2
RUN ./bootstrap --no-system-libs
RUN make
RUN make install
# Next, PortAudio is required to record microphone data. Run this command to install and configure PortAudio:
RUN mkdir -p /home/root/sdk-folder/third-party \
 && cd /home/root/sdk-folder/third-party
RUN wget -c http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz
RUN tar zxf pa_stable_v190600_20161030.tgz
RUN cd portaudio
RUN ./configure --without-jack
RUN make
# commentjson is required to parse comments in AlexaClientSDKConfig.json. Run this command to install commentjson:
RUN easy_install pip
RUN pip install --upgrade pip
RUN pip install commentjson
# Clone the AVS Device SDK and the Sensory wake word engine
RUN mkdir -p /home/root/sdk-folder/sdk-source \
 && cd /home/root/sdk-folder/sdk-source
RUN git clone git://github.com/alexa/avs-device-sdk.git
# Next, let's clone the sensory wake word engine into our third-party directory:
RUN cd /home/root/sdk-folder/third-party
RUN git clone git://github.com/Sensory/alexa-rpi.git
# Now let's run the licensing script and accept the licensing agreement. This is required to use Sensory's wake word engine:
RUN cd /home/root/sdk-folder/third-party/alexa-rpi/bin/
RUN yes | ./license.sh
# Run cmake to generate the build dependencies. This command declares that the wake word engine and gstreamer are enabled, and provides paths to the wake word engine and PortAudio:
RUN mkdir -p /home/root/sdk-folder/sdk-build \
 && cd /home/root/sdk-folder/sdk-build
RUN cmake /home/root/sdk-folder/sdk-source/avs-device-sdk -DSENSORY_KEY_WORD_DETECTOR=ON -DSENSORY_KEY_WORD_DETECTOR_LIB_PATH=/home/root/sdk-folder/third-party/alexa-rpi/lib/libsnsr.a -DSENSORY_KEY_WORD_DETECTOR_INCLUDE_DIR=/home/root/sdk-folder/third-party/alexa-rpi/include -DGSTREAMER_MEDIA_PLAYER=ON -DPORTAUDIO=ON -DPORTAUDIO_LIB_PATH=/home/root/sdk-folder/third-party/portaudio/lib/.libs/libportaudio.a -DPORTAUDIO_INCLUDE_DIR=/home/root/sdk-folder/third-party/portaudio/include

RUN [ "cross-build-end" ]

ENTRYPOINT ./workspace/entrypoint.sh