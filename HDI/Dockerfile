FROM ubuntu:16.04

# initial setup and update
ENV LC_ALL=en_AU.UTF-8
ENV LANGUAGE=en_AU.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y locales && locale-gen en_AU.UTF-8 && apt-get install -y git

# get the HDI repo
RUN git clone https://github.com/Nicola17/High-Dimensional-Inspector.git /opt/High-Dimensional-Inspector
WORKDIR /opt/High-Dimensional-Inspector

# install HDI (recreating install script)
RUN apt-get install build-essential libgl1-mesa-dev 
RUN add-apt-repository ppa:beineri/opt-qt551-trusty -y && apt-get update
RUN apt-get install qt55base qt55-meta-full -y
RUN mkdir /etc/xdg/qtchooser && touch /etc/xdg/qtchooser/default.conf
RUN printf "/opt/qt55/bin\n/opt/qt55/lib" | tee /etc/xdg/qtchooser/default.conf

# install dependency: cdroaring
RUN apt-get install libflann-dev
RUN git clone https://github.com/RoaringBitmap/CRoaring.git && cd CRoaring && mkdir -p build && cd build && cmake  -DCMAKE_BUILD_TYPE=Release .. && make -j && make install && cd ../.. && rm -rf CRoaring

# complete install of HDI
RUN mkdir build && cd build && cmake  -DCMAKE_BUILD_TYPE=Release .. && make -j && make install