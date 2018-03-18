set INCLUDE=C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\VC\\INCLUDE;C:\\Program Files (x86)\\Windows Kits\\8.1\\Include\\um\\;C:\\Program Files (x86)\\Windows Kits\\8.1\\Include\\shared\\;C:\\Program Files (x86)\\Windows Kits\\10\\include\\10.0.10240.0\\ucrt

set PREV_PATH=%PATH%
set PATH=C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\VC\\bin\\amd64;C:\\Program Files (x86)\\Windows Kits\\8.1\\bin\\x64;%PATH%

set LIB=C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\VC\\LIB\\amd64;C:\\Program Files (x86)\\Windows Kits\\8.1\\lib\\winv6.3\\um\\x64;C:\\Program Files (x86)\\Windows Kits\\10\\Lib\\10.0.10150.0\\ucrt\\x64
bash ./build_x265.sh mingw_msvc_x64

set PATH=%PREV_PATH%

rem ----------------------------------------

set PREV_PATH=%PATH%
set PATH=C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\VC\\bin;C:\\Program Files (x86)\\Windows Kits\\8.1\\bin\\x86;%PATH%

set LIB=C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\VC\\LIB;C:\\Program Files (x86)\\Windows Kits\\8.1\\lib\\winv6.3\\um\\x86;C:\\Program Files (x86)\\Windows Kits\\10\\Lib\\10.0.10150.0\\ucrt\\x86
bash ./build_x265.sh mingw_msvc_x86

set PATH=%PREV_PATH%
