#!/bin/bash

set -x

if [[ "$OSTYPE" == "linux-gnu" ]]; then

    sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get dist-upgrade -y; apt-get autoremove -y; apt-get autoclean -y'

    sudo apt install -y wget
    sudo apt install -y flex texinfo bison
    sudo apt install -y build-essential
    sudo apt install -y libmpc-dev
    sudo apt install -y pkg-config
    sudo apt install -y cmake
    sudo apt install -y mc


#from handsbrake
    sudo apt install -y autoconf
    sudo apt install -y python
    sudo apt install -y zlib1g-dev
    sudo apt install -y libtool-bin
    sudo apt install -y yasm

    sudo apt install -y autoconf
    sudo apt install -y automake
    sudo apt install -y build-essential
    sudo apt install -y cmake
    sudo apt install -y curl
    sudo apt install -y gcc
    sudo apt install -y git
    sudo apt install -y libtool
    sudo apt install -y libtool-bin
    sudo apt install -y m4
    sudo apt install -y make
    sudo apt install -y patch
    sudo apt install -y pkg-config
    sudo apt install -y python
    sudo apt install -y tar
    sudo apt install -y yasm
    sudo apt install -y zlib1g-dev
    sudo apt install -y ragel
fi

