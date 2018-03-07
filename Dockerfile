FROM dorowu/ubuntu-desktop-lxde-vnc
MAINTAINER jimako1989
USER root

WORKDIR /root
ENV HOME /root

# The first step is to make sure your machine has the latest package lists and then install the latest version of each package in that list:
RUN pwd\
 && apt-get update \
 && apt-get upgrade -y
# We need somewhere to put everything, so let's create some folders. This guide presumes that everything is built in ${HOME}, which we will presume is your home directory. If you choose to use different folder names, please update the commands throughout this guide accordingly:
RUN mkdir sdk-folder \
 && cd sdk-folder \
 && mkdir sdk-build sdk-source third-party application-necessities
# Now, let's set up our toolchain:
RUN apt-get install -y git gcc openssl clang-format wget
# Installing latest cmake
RUN cd ~/sdk-folder/third-party \
 && wget https://cmake.org/files/v3.10/cmake-3.10.2.tar.gz \
 && tar -zxvf cmake-3.10.2.tar.gz \
 && cd cmake-3.10.2 \
 && ./configure \
 && make \
 && make install
# Next, we need to download dependencies available from apt-get:
RUN apt-get install -y openssl libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-good libgstreamer-plugins-good1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-libav pulseaudio doxygen libsqlite3-dev repo libasound2-dev
# Let's install nghttp2. Note: This command will download and install dependencies for nghttp2:
RUN apt-get install -y g++ make binutils autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libev-dev libevent-dev libjansson-dev libjemalloc-dev cython python3-dev python-setuptools
# Now, let's build nghttp2 from source:
RUN cd ~/sdk-folder/third-party \
 && git clone https://github.com/tatsuhiro-t/nghttp2.git \
 && cd nghttp2 \
 && autoreconf -i \
 && automake \
 && autoconf \
 && ./configure \
 && make \
 && make install
# Download the latest version of curl and configure with support for nghttp2 and openssl:
RUN cd ~/sdk-folder/third-party \
 && wget http://curl.haxx.se/download/curl-7.54.0.tar.bz2 \
 && tar -xvjf curl-7.54.0.tar.bz2 \
 && cd curl-7.54.0 \
 && ./configure --with-nghttp2=/usr/local --with-ssl \
 && make \
 && make install \
 && ldconfig
# Test curl:
RUN curl -I https://nghttp2.org/
# PortAudio is required to record microphone data. Run this command to install and configure PortAudio:
RUN cd ~/sdk-folder/third-party \
 && wget -c http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz && tar zxf pa_stable_v190600_20161030.tgz && cd portaudio && ./configure --without-jack && make
# Now it's time to clone the AVS Device SDK. Navigate to your sdk-source folder and run this command:
RUN cd ~/sdk-folder/sdk-source && git clone git://github.com/alexa/avs-device-sdk.git
# Assuming the download succeeded, the next step is to build the SDK. This command does a few things:
RUN cd ${HOME}/sdk-folder/sdk-build && cmake ${HOME}/sdk-folder/sdk-source/avs-device-sdk -DSENSORY_KEY_WORD_DETECTOR=OFF -DGSTREAMER_MEDIA_PLAYER=ON -DPORTAUDIO=ON -DPORTAUDIO_LIB_PATH=${HOME}/sdk-folder/third-party/portaudio/lib/.libs/libportaudio.a -DPORTAUDIO_INCLUDE_DIR=${HOME}/sdk-folder/third-party/portaudio/include && make
# The AVS Device SDK uses a sample authorization service build in Python to obtain refresh and access tokens. In this step, we'll install PIP and other dependencies for the authorization service:
RUN easy_install pip \
 && pip install --upgrade pip \
 && pip install --user flask requests commentjson
# Audio card
RUN apt-get install -y pulseaudio alsa-utils socat \
 & pulseaudio -D --exit-idle-time=-1 \
 & pacmd load-module module-pipe-source file=/dev/audio format=s16 rate=44100 channels=2 \
 & socat tcp-listen:3000 file:/dev/audio &
# Mkdir to mount the volume
RUN mkdir /root/workspace