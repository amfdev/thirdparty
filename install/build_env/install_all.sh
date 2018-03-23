#!/bin/bash

set -x

ROOT_DIR=$PWD

. "$ROOT_DIR/../../scripts/toolset/common" || exit 1

echo 'start time' `date` > $LOG_FILE

rm -fR _build*

chmod +x $ROOT_DIR/../../scripts/time.sh
chmod +x ./*.sh

time.sh ./install_deps.sh
time.sh ./install_mingw.sh

time.sh ./install_nasm.sh
time.sh ./install_mingw-gdb.sh
time.sh ./install_sdl2.sh
time.sh ./install_x264.sh
time.sh ./install_x265.sh

echo 'end time' `date` >> $LOG_FILE