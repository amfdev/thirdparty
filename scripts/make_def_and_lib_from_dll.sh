#set -x
#--------------------------------------------------------
#create def and lib file from dll
#--------------------------------------------------------
function make_def_and_lib_from_dll
{
  dllname=$1
  libname=$2

  rm -f ${libname}.txt
  rm -f ${libname}.def
  rm -f ${libname}

  dumpbin.exe -exports ${dllname} > ${libname}.txt

  echo EXPORTS >> ${libname}.def

  sed -e '1,19d' ${libname}.txt |
  while read line; do
    eval array=($line)
    if [ "${array[3]}" != "" ]
    then
        echo ${array[3]}>> ${libname}.def
    fi
  done

  lib.exe -MACHINE:${LIB_ARCH} -DEF:"${libname}.def" -OUT:"${libname}" -NAME:"${dllname}"
}
