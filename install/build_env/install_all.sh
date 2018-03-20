#!/bin/bash

set -x

sudo install_deps.sh
./install_nasm.sh

ROOT_DIR=$PWD

if [ -z "$PREFIX" ]; then
    PREFIX=${ROOT_DIR}/../../libs/mingw-w64
    rm -fR $PREFIX
    mkdir -p $PREFIX
    PREFIX=`readlink -f ${PREFIX}`
fi

rm -fR _build*

[ -z "$LOG_FILE" ] && LOG_FILE=$ROOT_DIR/log.txt && echo 'time' `date` > $LOG_FILE


export PREFIX
export LOG_FILE

./install_mingw.sh
./install_mingw-gdb.sh
./install_sdl2.sh
./install_x264.sh
./install_x265.sh

echo 'time' `date` >> $LOG_FILE