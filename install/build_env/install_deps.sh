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
fi

