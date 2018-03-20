#!/bin/bash

set -x

ROOT_DIR=$PWD

. "$ROOT_DIR/../../scripts/toolset/common" || exit 1


sudo install_deps.sh
./install_nasm.sh


if [ -z "$PREFIX" ]; then
    PREFIX=${ROOT_DIR}/mingw-w64
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