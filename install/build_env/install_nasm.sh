#!/bin/bash

set -x

NASM_VER=2.13.03
ROOT_DIR=$PWD
WORK_DIR=$ROOT_DIR/_build_nasm

mkdir -p ${WORK_DIR} && cd ${WORK_DIR} || exit 1

wget --timestamping http://www.nasm.us/pub/nasm/releasebuilds/${NASM_VER}/nasm-${NASM_VER}.tar.xz

rm -fR nasm-${NASM_VER}

tar -xvf nasm-${NASM_VER}.tar.xz

cd nasm-${NASM_VER}/

./configure && make && sudo make install

cd $ROOT_DIR