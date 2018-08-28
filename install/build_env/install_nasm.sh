#!/bin/bash

set -x

sudo

ROOT_DIR=$PWD

if [ -f $ROOT_DIR/../../scripts/toolset/common ]; then
. $ROOT_DIR/../../scripts/toolset/common
fi

[ -z "$MINGW_DIR" ] && MINGW_DIR=`readlink -f ${ROOT_DIR}/../../libs/mingw-w64`
[ ! -d "${MINGW_DIR}" ] && echo MINGW_DIR is not set due missing folder && exit 1

CURRENT_PATH=$PATH

[ -z "$PROC_NUM" ] && PROC_NUM=1

WORK_DIR=$ROOT_DIR/_build_mingw-nasm
mkdir -p ${WORK_DIR} && cd ${WORK_DIR} || exit 1

[ -z "$LOG_FILE" ] && LOG_FILE=$WORK_DIR/log.txt && echo 'time' > $LOG_FILE


NASM_VER=2.13.03
SOURCE_DIR=${WORK_DIR}/nasm-${NASM_VER}
rm -fR ${SOURCE_DIR}

curl -k https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VER}/nasm-${NASM_VER}.tar.xz --output ./nasm-${NASM_VER}.tar.xz
tar -xvf nasm-${NASM_VER}.tar.xz

for ARCH in x86_64 i686; do
    echo start $ARCH `date` >> $LOG_FILE

    ARCH_DIR=${MINGW_DIR}/mingw-w64-${ARCH}
    TARGET=${ARCH}-w64-mingw32
    BUILD_DIR=${WORK_DIR}/build-${ARCH}

    rm -fR ${BUILD_DIR}
    mkdir -p ${BUILD_DIR} && cd ${BUILD_DIR} || exit 1

    cp -r ${SOURCE_DIR}/* .
    ${SOURCE_DIR}/configure --prefix="$ARCH_DIR"
    make -j${PROC_NUM} && sudo make install || exit 1

    echo end $ARCH `date` >> $LOG_FILE
done

cd ${ROOT_DIR}

