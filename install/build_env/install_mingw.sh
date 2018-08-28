#!/bin/bash

./mingw-w64-build i686
./mingw-w64-build x86_64
./mingw-w64-build i686.clean
./mingw-w64-build x86_64.clean
./mingw-w64-build pkgclean
