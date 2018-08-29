#!/bin/bash

set -x

if [[ "$OSTYPE" == "linux-gnu" ]]; then

    sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get dist-upgrade -y; apt-get autoremove -y; apt-get autoclean -y'

    sudo apt update
    sudo apt install -y autoconf automake build-essential \
                cmake git libass-dev libbz2-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev \
                libharfbuzz-dev libjansson-dev libmp3lame-dev libogg-dev libopus-dev libsamplerate-dev \
                libtheora-dev libtool libvorbis-dev libx264-dev \
                libxml2-dev m4 make patch pkg-config python tar yasm zlib1g-dev

    sudo apt install -y intltool libappindicator-dev libdbus-glib-1-dev libglib2.0-dev \
                libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
                libgtk-3-dev libgudev-1.0-dev libnotify-dev libwebkitgtk-3.0-dev


    sudo apt install -y wget
    sudo apt install -y flex texinfo bison pax
    sudo apt install -y libtool-bin

    sudo apt install -y mc

fi

