FROM ubuntu:22.04

RUN apt-get update && apt-get install git python3 python-is-python3 wget -y && apt-get clean
RUN wget -O /usr/bin/nix https://hydra.nixos.org/build/222822347/download/1/nix && chmod 755 /usr/bin/nix