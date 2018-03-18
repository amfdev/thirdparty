#!/bin/bash
#set -x

ROOT_DIR=$PWD
TOOLS_DIR=$ROOT_DIR/../../scripts

. "${TOOLS_DIR}/toolset/$1"

BUILD_DIR=$ROOT_DIR/_build-$1
REDIST_DIR=$ROOT_DIR/../../libs/x265/$1
SOURCE_DIR=$ROOT_DIR/x265/source

rm -fR $BUILD_DIR
rm -fR $REDIST_DIR
mkdir -p $BUILD_DIR
mkdir -p $REDIST_DIR
mkdir -p $REDIST_DIR/bin
mkdir -p $REDIST_DIR/include
mkdir -p $REDIST_DIR/lib

cd $BUILD_DIR

if [ "$COMPILER" == "msvc" ]
then
    /mnt/c/CMake/bin/cmake.exe -G "NMake Makefiles" -DCMAKE_CXX_FLAGS="-DWIN32 -D_WINDOWS -W4 -GR -EHsc" \
                -DCMAKE_C_FLAGS="-DWIN32 -D_WINDOWS -W4" \
                -DCMAKE_INSTALL_PREFIX="./../../../libs/x265/$1" \
                ../x265/source
    nmake.exe
else
    cmake -G "Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=${TOOLS_DIR}/toolset/${1}.cmake \
                -DCMAKE_CXX_FLAGS="-static-libgcc -static-libstdc++ -static"\
                -DCMAKE_C_FLAGS="-static-libgcc -static-libstdc++ -static"\
                -DCMAKE_SHARED_LIBRARY_LINK_C_FLAGS="-static-libgcc -static-libstdc++" \
                -DCMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS="-static-libgcc -static-libstdc++" \
                -DCMAKE_INSTALL_PREFIX="./../../../libs/x265/$1" \
                ${SOURCE_DIR}
    make -j${NPROC}

    . "${TOOLS_DIR}/make_def_and_lib_from_dll.sh"
    make_def_and_lib_from_dll libx265.dll libx265.lib
fi


cd $ROOT_DIR

cp -v $BUILD_DIR/x265.pc          $REDIST_DIR

cp -v $SOURCE_DIR/x265.h          $REDIST_DIR/include
cp -v $BUILD_DIR/x265_config.h    $REDIST_DIR/include
cp -v $BUILD_DIR/*.dll            $REDIST_DIR/bin
cp -v $BUILD_DIR/*.exe            $REDIST_DIR/bin

if [ "$COMPILER" == "msvc" ]
then
    cp -v $BUILD_DIR/libx265.lib $REDIST_DIR/lib/x265.lib
    cp -v $BUILD_DIR/libx265.lib $REDIST_DIR/lib/libx265.lib
else
    cp -v $BUILD_DIR/libx265.lib $REDIST_DIR/lib/x265.a
    cp -v $BUILD_DIR/libx265.lib $REDIST_DIR/lib/libx265.a
#    cp -v $BUILD_DIR/libx265.dll.a $REDIST_DIR/x265.a
#    cp -v $BUILD_DIR/libx265.dll.a $REDIST_DIR/libx265.a
fi

rm -fR $BUILD_DIR
