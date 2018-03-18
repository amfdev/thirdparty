wsl ./fetch_x264.sh

wsl ./build_x264_gcc.sh
call build_x264_msvc14.bat

wsl rm -fR ./x264