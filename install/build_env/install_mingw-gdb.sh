#!/bin/bash

set -x

ROOT_DIR=$PWD

if [ -f $ROOT_DIR/../../scripts/toolset/common ]; then
. $ROOT_DIR/../../scripts/toolset/common
fi

CURRENT_PATH=$PATH

[ -z "$PROC_NUM" ] && PROC_NUM=1

[ -z "$MINGW_DIR" ] && MINGW_DIR=`readlink -f ${ROOT_DIR}/../../libs/mingw-w64`
[ ! -d "${MINGW_DIR}" ] && echo MINGW_DIR is not set due missing folder && exit 1

WORK_DIR=$ROOT_DIR/_build_mingw-gdb
BUILD_GDB=1
BUILD_GDB_WIN=1
mkdir -p ${WORK_DIR} && cd ${WORK_DIR} || exit 1

[ -z "$LOG_FILE" ] && LOG_FILE=$WORK_DIR/log.txt && echo 'time' > $LOG_FILE

GDB_SRC=gdb-8.1

curl -k https://ftp.heikorichter.name/gnu/gdb/${GDB_SRC}.tar.xz --output ./${GDB_SRC}.tar.xz
[ ! -d "${GDB_SRC}" ] && tar -xf ${GDB_SRC}.tar.xz

for ARCH in x86_64 i686; do
    echo start $ARCH `date` >> $LOG_FILE

    ARCH_DIR=${MINGW_DIR}/mingw-w64-${ARCH}
    TARGET=${ARCH}-w64-mingw32
    SYSTROOT="--with-sysroot=${ARCH_DIR}"

    cd ${WORK_DIR}
    if [ "$BUILD_GDB" == "1" ]; then
        cd ${GDB_SRC}
        rm -fR build-gdb-${ARCH}
        mkdir -p build-gdb-${ARCH} && cd build-gdb-${ARCH} || exit 1
        ../configure --target=${TARGET} --prefix=${ARCH_DIR} || exit 1
        make -j${PROC_NUM} && make install || exit 1
        cd ${WORK_DIR}
    fi

    export PATH="${ARCH_DIR}/bin:$PATH"

    if [ "$BUILD_GDB_WIN" == "1" ]; then
        cd ${GDB_SRC}
        rm -fR build-gdb-win-${ARCH}
        mkdir -p build-gdb-win-${ARCH} && cd build-gdb-win-${ARCH} || exit 1
        ../configure --host=${TARGET} --target=${TARGET} --prefix=${ARCH_DIR}/$TARGET/windows || exit 1
        make -j${PROC_NUM} && make install || exit 1
        cd ${WORK_DIR}
    fi


    cd ${GDB_SRC}
    rm -fR build-gdbserver-${ARCH}
    mkdir -p build-gdbserver-${ARCH} && cd build-gdbserver-${ARCH} || exit 1
    export LDFLAGS="-static-libgcc -static-libstdc++"
    ../gdb/gdbserver/configure --host=${TARGET} --prefix=${ARCH_DIR}/$TARGET/windows || exit 1
    make -j${PROC_NUM} && make install || exit 1
    cd ${WORK_DIR}

    echo end $ARCH `date` >> $LOG_FILE
done

cd ${ROOT_DIR}

