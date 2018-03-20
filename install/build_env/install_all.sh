#!/bin/bash

set -x

ROOT_DIR=$PWD

. "$ROOT_DIR/../../scripts/toolset/common" || exit 1

echo 'start time' `date` > $LOG_FILE

rm -fR _build*


time.sh ./install_deps.sh
time.sh ./install_nasm.sh


if [ -z "$PREFIX" ]; then
    PREFIX=${ROOT_DIR}/mingw-w64
    rm -fR $PREFIX
    mkdir -p $PREFIX
    PREFIX=`readlink -f ${PREFIX}`
fi





time.sh ./install_mingw.sh
time.sh ./install_mingw-gdb.sh
time.sh ./install_sdl2.sh
time.sh ./install_x264.sh
time.sh ./install_x265.sh

echo 'end time' `date` >> $LOG_FILE