FROM ubuntu:16.04

# initial setup and update
ENV LC_ALL=en_AU.UTF-8
ENV LANGUAGE=en_AU.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y locales && locale-gen en_AU.UTF-8 && apt-get install -y git software-properties-common wget

# get the HDI repo
RUN git clone https://github.com/Nicola17/High-Dimensional-Inspector.git /opt/High-Dimensional-Inspector
WORKDIR /opt/High-Dimensional-Inspector

# installing turbovnc and virtualgl
RUN wget https://swift.rc.nectar.org.au/v1/AUTH_810/CVL-Singularity-External-Files/turbovnc_2.2.5_amd64.deb && apt-get install -y ./turbovnc_2.2.5_amd64.deb && rm ./turbovnc_2.2.5_amd64.deb
RUN wget https://swift.rc.nectar.org.au/v1/AUTH_810/CVL-Singularity-External-Files/virtualgl_2.6.4_amd64.deb && apt-get install -y ./virtualgl_2.6.4_amd64.deb && rm ./virtualgl_2.6.4_amd64.deb 

# install HDI (recreating install script)
RUN apt-get install build-essential libgl1-mesa-dev cmake -y
RUN apt-get install qt5-default libqt5webkit5 libqt5webkit5-dev x11-xserver-utils mesa-utils libxv1 libgl1-mesa-glx libgl1-mesa-dri -y

# install dependency: cdroaring
RUN apt-get install libflann-dev -y
RUN git clone https://github.com/RoaringBitmap/CRoaring.git -b v0.2.66 && cd CRoaring && mkdir -p build && cd build && cmake  -DCMAKE_BUILD_TYPE=Release .. && make -j && make install && cd ../.. && rm -rf CRoaring

# complete install of HDI
RUN mkdir build && cd build && cmake  -DCMAKE_BUILD_TYPE=Release .. && make -j && make install