#!/bin/bash

set -x

ROOT_DIR=$PWD

PREFIX=`readlink -f ${ROOT_DIR}/../../libs/mingw-w64`
[ ! -d "${PREFIX}" ] && echo PREFIX is not set due missing folder && exit 1

CURRENT_PATH=$PATH

PROC_NUM=`nproc --all`

WORK_DIR=$ROOT_DIR/_build_mingw-x265
mkdir -p ${WORK_DIR} && cd ${WORK_DIR} || exit 1

LOG_FILE=$WORK_DIR/log.txt
echo 'time' > $LOG_FILE

SOURCE_DIR=${WORK_DIR}/x265
rm -fR ${SOURCE_DIR}
git clone https://github.com/amfdev/x265.git ${SOURCE_DIR}



for ARCH in x86_64 i686; do
    echo start $ARCH `date` >> $LOG_FILE

    ARCH_DIR=${PREFIX}/toolchain-${ARCH}
    TARGET=${ARCH}-w64-mingw32
    #REDIST_DIR=$ROOT_DIR/../../libs/x265/$TARGET
    BUILD_DIR=${WORK_DIR}/build-${ARCH}

    export PATH="${ARCH_DIR}/bin:$CURRENT_PATH"
    export LDFLAGS="-static-libgcc -static-libstdc++"

    rm -fR ${BUILD_DIR}
    mkdir -p ${BUILD_DIR} && cd ${BUILD_DIR} || exit 1

    cmake -G "Unix Makefiles"  \
                -DCMAKE_SYSTEM_NAME=Windows \
                -DCMAKE_C_COMPILER=${TARGET}-gcc \
                -DCMAKE_RC_COMPILER=${TARGET}-windres \
                -DCMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS="-static-libgcc -static-libstdc++" \
                -DCMAKE_INSTALL_PREFIX="$ARCH_DIR/$TARGET" \
                -DENABLE_SHARED=OFF \
                ${SOURCE_DIR}/source
    make -j${NPROC}
    make install

    echo end $ARCH `date` >> $LOG_FILE
done

cd ${ROOT_DIR}

