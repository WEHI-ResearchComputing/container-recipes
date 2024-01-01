FROM ubuntu:16.04

# initial setup and update
ENV LC_ALL=en_AU.UTF-8
ENV LANGUAGE=en_AU.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y locales && locale-gen en_AU.UTF-8

RUN git clone https://github.com/Nicola17/High-Dimensional-Inspector.git /opt/High-Dimensional-Inspector
WORKDIR /opt/High-Dimensional-Inspector
RUN ./scripts/install-dependencies.sh && mkdir build && cd build cmake  -DCMAKE_BUILD_TYPE=Release .. && make -j && make install