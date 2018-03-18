SOURCE=./AMF
REDIST=../../libs/AMF

rm -fR ${REDIST}
mkdir -p ${REDIST}/include/AMF
cp -R ${SOURCE}/amf/public/include/* ${REDIST}/include/AMF
