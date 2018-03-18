#!/bin/bash

set -x

ROOT_DIR=$PWD
WORK_DIR=$ROOT_DIR/_build_mingw-gdb

mkdir -p ${WORK_DIR} && cd ${WORK_DIR} || exit 1

LOG_FILE=$WORK_DIR/log.txt
echo 'time' > $LOG_FILE

GDB_SRC=gdb-8.1

PREFIX=`readlink -f ${ROOT_DIR}/../../libs/mingw-w64`

wget  --timestamping http://ftp.heikorichter.name/gnu/gdb/${GDB_SRC}.tar.xz || exit 1

[ ! -d "${GDB_SRC}" ] && tar -xf ${GDB_SRC}.tar.xz


PROC_NUM=`nproc --all`

for ARCH in x86_64 i686; do
    echo start $ARCH `date` >> $LOG_FILE

    ARCH_DIR=${PREFIX}/toolchain-${ARCH}
    TARGET=${ARCH}-w64-mingw32
    SYSTROOT="--with-sysroot=${ARCH_DIR}"

    cd ${WORK_DIR}



    if [ "$BUILD_GDB" == "1" ]; then
        cd ${GDB_SRC}
        rm -fR build-gdb-${ARCH}
        mkdir -p build-gdb-${ARCH} && cd build-gdb-${ARCH} || exit 1
        ../configure --target=${TARGET} --prefix=${ARCH_DIR} --disable-multilib ${SYSTROOT} || exit 1
        make -j${PROC_NUM} && sudo make install || exit 1
        cd ${WORK_DIR}
    fi

    export PATH="${ARCH_DIR}/bin:$PATH"

    cd ${GDB_SRC}
    rm -fR build-gdbserver-${ARCH}
    mkdir -p build-gdbserver-${ARCH} && cd build-gdbserver-${ARCH} || exit 1
    export LDFLAGS="-static-libgcc -static-libstdc++"
    ../gdb/gdbserver/configure --host=${TARGET} --prefix=${ARCH_DIR} --program-prefix=${TARGET}- || exit 1
    make -j${PROC_NUM} && sudo make install || exit 1
    cd ${WORK_DIR}

    echo end $ARCH `date` >> $LOG_FILE
done

cd ${ROOT_DIR}

