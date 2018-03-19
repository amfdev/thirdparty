#!/bin/bash

set -x

ROOT_DIR=$PWD

[ -z "$PREFIX" ] && PREFIX=`readlink -f ${ROOT_DIR}/../../libs/mingw-w64`
[ ! -d "${PREFIX}" ] && echo PREFIX is not set due missing folder && exit 1

CURRENT_PATH=$PATH

PROC_NUM=`nproc --all`

WORK_DIR=$ROOT_DIR/_build_mingw-sdl2
mkdir -p ${WORK_DIR} && cd ${WORK_DIR} || exit 1

[ -z "$LOG_FILE" ] && LOG_FILE=$WORK_DIR/log.txt && echo 'time' > $LOG_FILE

SOURCE_DIR=${WORK_DIR}/SDL
rm -fR ${SOURCE_DIR}
git clone https://github.com/SDL-mirror/SDL.git ${SOURCE_DIR}



for ARCH in x86_64 i686; do
    echo start $ARCH `date` >> $LOG_FILE

    ARCH_DIR=${PREFIX}/toolchain-${ARCH}
    TARGET=${ARCH}-w64-mingw32
    #REDIST_DIR=$ROOT_DIR/../../libs/SDL/$TARGET
    BUILD_DIR=${WORK_DIR}/build-${ARCH}

    export PATH="${ARCH_DIR}/bin:$CURRENT_PATH"
    export LDFLAGS="-static-libgcc -static-libstdc++"

    rm -fR ${BUILD_DIR}
    mkdir -p ${BUILD_DIR} && cd ${BUILD_DIR} || exit 1

    ${SOURCE_DIR}/configure --host=${TARGET} --prefix="$ARCH_DIR/$TARGET" --enable-shared=false
    make -j${PROC_NUM} && make install


    echo end $ARCH `date` >> $LOG_FILE
done

cd ${ROOT_DIR}

