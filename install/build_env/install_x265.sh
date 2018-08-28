#!/bin/bash

set -x

ROOT_DIR=$PWD

if [ -f $ROOT_DIR/../../scripts/toolset/common ]; then
. $ROOT_DIR/../../scripts/toolset/common
fi

[ -z "$MINGW_DIR" ] && MINGW_DIR=`readlink -f ${ROOT_DIR}/../../libs/mingw-w64`
[ ! -d "${MINGW_DIR}" ] && echo MINGW_DIR is not set due missing folder && exit 1

CURRENT_PATH=$PATH

[ -z "$PROC_NUM" ] && PROC_NUM=1

WORK_DIR=$ROOT_DIR/_build_mingw-x265
mkdir -p ${WORK_DIR} && cd ${WORK_DIR} || exit 1

[ -z "$LOG_FILE" ] && LOG_FILE=$WORK_DIR/log.txt && echo 'time' > $LOG_FILE

SOURCE_DIR=${WORK_DIR}/x265
rm -fR ${SOURCE_DIR}
git clone https://github.com/amfdev/x265.git ${SOURCE_DIR}

for ARCH in x86_64 i686; do
    echo start $ARCH `date` >> $LOG_FILE

    ARCH_DIR=${MINGW_DIR}/mingw-w64-${ARCH}
    TARGET=${ARCH}-w64-mingw32
    BUILD_DIR=${WORK_DIR}/build-${ARCH}

    export PATH="${ARCH_DIR}/bin:$CURRENT_PATH"
    export LDFLAGS="-static-libgcc -static-libstdc++"

    rm -fR ${BUILD_DIR}
    mkdir -p ${BUILD_DIR} && cd ${BUILD_DIR} || exit 1

    cmake -G "Unix Makefiles"  \
                -DCMAKE_SYSTEM_NAME=Windows \
                -DCMAKE_C_COMPILER=${TARGET}-gcc \
                -DCMAKE_RC_COMPILER=${TARGET}-windres \
                -DCMAKE_MODULE_LINKER_FLAGS="-static-libgcc -static-libstdc++" \
                -DCMAKE_CXX_FLAGS="-static-libgcc -static-libstdc++" \
                -DCMAKE_C_FLAGS="-static-libgcc -static-libstdc++" \
                -DCMAKE_INSTALL_PREFIX="$ARCH_DIR/$TARGET" \
                -DENABLE_SHARED=ON \
                -DENABLE_CLI=OFF \
                ${SOURCE_DIR}/source
    make -j${PROC_NUM}
    make install

    echo end $ARCH `date` >> $LOG_FILE
done

cd ${ROOT_DIR}

