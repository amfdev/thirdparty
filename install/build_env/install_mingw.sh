#!/bin/bash

set -x

ROOT_DIR=$PWD
WORK_DIR=$ROOT_DIR/_build_mingw
mkdir -p ${WORK_DIR} && cd ${WORK_DIR} || exit 1

LOG_FILE=$WORK_DIR/log.txt
echo 'time' > $LOG_FILE

BINUTILS_SRC=binutils-2.30
MINGW_SRC=mingw-w64-v5.0.3
GCC_SRC=gcc-5.5.0

rm -fR $BINUTILS_SRC
rm -fR $MINGW_SRC
rm -fR $GCC_SRC

wget  --timestamping http://ftp.heikorichter.name/gnu/gcc/${GCC_SRC}/${GCC_SRC}.tar.xz || exit 1
wget  --timestamping http://ftp.heikorichter.name/gnu/binutils/${BINUTILS_SRC}.tar.xz || exit 1
wget  --timestamping --no-check-certificate https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/${MINGW_SRC}.tar.bz2/download -O ${MINGW_SRC}.tar.bz2 || exit 1

tar -xf ${GCC_SRC}.tar.xz
tar -xf ${BINUTILS_SRC}.tar.xz
tar -xf ${MINGW_SRC}.tar.bz2

BUILD_BINUTIL=1
BUILD_MINGW_HEADERS=1
BUILD_GCC=1
BUILD_MINGW_CRT=1
BUILD_GCC_FINAL=1

BINUTILS_SRC=binutils-2.30
MINGW_SRC=mingw-w64-v5.0.3
GCC_SRC=gcc-5.5.0
PROC_NUM=`nproc --all`


PREFIX=/usr/mingw-w64

sudo rm -fR $PREFIX

for ARCH in x86_64 i686; do
    echo start $ARCH `date` >> $LOG_FILE

    ARCH_DIR=${PREFIX}/toolchain-${ARCH}
    TARGET=${ARCH}-w64-mingw32
    SYSTROOT="--with-sysroot=${ARCH_DIR}"
    SYSTROOTEX="--with-sysroot=${ARCH_DIR}/${TARGET}"
    cd ${WORK_DIR}


    #--enable-targets=${TARGET} 

    if [ "$BUILD_BINUTIL" == "1" ]; then
        cd ${BINUTILS_SRC}
        rm -fR build-${ARCH}
        mkdir -p build-${ARCH} && cd build-${ARCH} || exit 1
        ../configure --target=${TARGET} --prefix=${ARCH_DIR} --disable-multilib ${SYSTROOT} || exit 1
        make -j${PROC_NUM} || exit 1
        sudo make install || exit 1
        cd ${WORK_DIR}

        export PATH="$PATH:${ARCH_DIR}/bin"
    fi


    if [ "$BUILD_MINGW_HEADERS" == "1" ]; then
        cd ${MINGW_SRC}/mingw-w64-headers
        rm -fR build-${ARCH}
        mkdir -p build-${ARCH} && cd build-${ARCH} || exit 1
        ../configure --host=${TARGET} --prefix=${ARCH_DIR}/${TARGET} || exit 1
        make || exit 1
        sudo make install || exit 1
        sudo ln -s ${ARCH_DIR}/${TARGET} ${ARCH_DIR}/mingw || exit 1
        sudo mkdir -p ${ARCH_DIR}/${TARGET}/lib || exit 1
        cd ${WORK_DIR}
    fi


    if [ "$BUILD_GCC" == "1" ]; then
        cd ${GCC_SRC}
        rm -fR build-${ARCH}
        mkdir -p build-${ARCH} && cd build-${ARCH} || exit 1
        ln -s automake-1.15 automake-1.14
        ln -s aclocal-1.15 aclocal-1.14

        ../configure --target=${TARGET} --prefix=${ARCH_DIR} --disable-multilib ${SYSTROOT} || exit 1
        make all-gcc -j${PROC_NUM} || exit 1
        sudo make install-gcc || exit 1
        cd ${WORK_DIR}
    fi

    if [ "$BUILD_MINGW_CRT" == "1" ]; then
        cd ${MINGW_SRC}/mingw-w64-crt
        mkdir -p build-${ARCH} && cd build-${ARCH} || exit 1

        [ "${ARCH}" == "i686" ] && ADD_ARG="--enable-lib32 --disable-lib64"
        [ "${ARCH}" == "x86_64" ] && ADD_ARG="--disable-lib32 --enable-lib64"
        TOOLS="CC=${TARGET}-gcc CXX=${TARGET}-g++ CPP=${TARGET}-cpp"

        ../configure --host=${TARGET} --prefix=${ARCH_DIR}/${TARGET} ${SYSTROOT} $ADD_ARG $TOOLS
        make -j${PROC_NUM} || exit 1
        sudo bash -c "PATH=\$PATH:${ARCH_DIR}/bin && env && make install" || exit 1

        cd ${WORK_DIR}
    fi

    if [ "$BUILD_GCC_FINAL" == "1" ]; then
        cd ${GCC_SRC}/build-${ARCH} || exit 1

        make -j${PROC_NUM} || exit 1
        sudo make install || exit 1
        cd ${WORK_DIR}
    fi

    echo end $ARCH `date` >> $LOG_FILE
done

cd ${ROOT_DIR}

