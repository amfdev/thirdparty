wsl ./fetch_x265.sh

wsl ./build_x265_gcc.sh
call build_x265_msvc14.bat

wsl rm -fR ./x265