#!/bin/sh

ARCHIVE=kissarchive
BUILD=build
PACKAGE=package

OS_NAME=$(uname -s)

export PATH="$PATH:${PWD}/prefix/bin:${PWD}/prefix/lib:/c/Qt/bin" 

rm -Rf ${PACKAGE}
mkdir -p ${PACKAGE}

PCOMPILER_PACKAGE=$(ls ${BUILD}/pcompiler-*)
LIBKOVANSERIAL_PACKAGE=$(ls ${BUILD}/libkovanserial-*)
LIBKAR_PACKAGE=$(ls ${BUILD}/libkar-*)
OPENCV_PACKAGE=$(ls ${BUILD}/opencv-*)

#######
# cs2 #
#######

CS2_BASE="${PACKAGE}/KISS.app"
CS2_EXTRAS="${CS2_BASE}"

# Mac OS X Bundle
if [[ ${OS_NAME} == "Darwin" ]]; then
	CS2_EXTRAS="${CS2_BASE}/cs2.app/Contents"
fi

# Install Base
mkdir -p ${CS2_BASE}
cp -r cs2/deploy/* ${CS2_BASE}

# These install the necessary shared libraries
LIBKOVAN_PACKAGE=$(ls ${BUILD}/libkovan-*)
LIBKOVAN_HOST_PACKAGE=$(ls ${BUILD}/libkovan_host-*)
OPENCV_HOST_PACKAGE=$(ls ${BUILD}/opencv_host-*)
ZBAR_PACKAGE=$(ls ${BUILD}/zbar-*)
ZBAR_HOST_PACKAGE=$(ls ${BUILD}/zbar_host-*)
kissarchive -e ${PCOMPILER_PACKAGE%.*} ${CS2_EXTRAS}
kissarchive -e ${LIBKAR_PACKAGE%.*} ${CS2_EXTRAS}
kissarchive -e ${LIBKOVANSERIAL_PACKAGE%.*} ${CS2_EXTRAS}
kissarchive -e ${ZBAR_HOST_PACKAGE%.*} ${CS2_EXTRAS}
kissarchive -e ${LIBKOVAN_HOST_PACKAGE%.*} ${CS2_EXTRAS}
kissarchive -e ${ZBAR_PACKAGE%.*} ${CS2_EXTRAS}/prefix
kissarchive -e ${LIBKOVAN_PACKAGE%.*} ${CS2_EXTRAS}/prefix
kissarchive -e ${OPENCV_PACKAGE%.*} ${CS2_EXTRAS}/prefix
kissarchive -e ${OPENCV_HOST_PACKAGE%.*} ${CS2_EXTRAS}
cp OpenNI2/Bin/x64-Release/libOpenNI2.dylib ${CS2_EXTRAS}/Frameworks/libOpenNI2.dylib
cp OpenNI2/Bin/x64-Release/libOpenNI2.dylib ${CS2_EXTRAS}/prefix/usr/lib/libOpenNI2.dylib

if [[ ${OS_NAME} == "Darwin" ]]; then
	echo "${CS2_EXTRAS}/MacOS/cs2"
	install_name_tool -change "lib/libopencv_core.3.0.dylib" "@executable_path/../Frameworks/libopencv_core.dylib" ${CS2_EXTRAS}/MacOS/cs2
	install_name_tool -change "lib/libopencv_highgui.3.0.dylib" "@executable_path/../Frameworks/libopencv_highgui.dylib" ${CS2_EXTRAS}/MacOS/cs2
	install_name_tool -change "lib/libopencv_imgproc.3.0.dylib" "@executable_path/../Frameworks/libopencv_imgproc.dylib" ${CS2_EXTRAS}/MacOS/cs2
	
	# Make libkovan use bundled libzbar
	framework_path="${PWD}/${CS2_BASE}/cs2.app/Contents/Frameworks"
	for i in $(ls -1 ${framework_path}/*.dylib)
        do
		install_name_tool -change "/usr/local/lib/libzbar.0.dylib" "@executable_path/../Frameworks/libzbar.0.dylib" ${i}
		install_name_tool -change "${CMAKE_PREFIX_PATH}/lib/QtCore.framework/Versions/5/QtCore" "@executable_path/../Frameworks/QtCore.framework/Versions/5/QtCore" ${i}
		install_name_tool -change "lib/libopencv_core.3.0.dylib" "@executable_path/../Frameworks/libopencv_core.dylib" ${i}
		install_name_tool -change "lib/libopencv_highgui.3.0.dylib" "@executable_path/../Frameworks/libopencv_highgui.dylib" ${i}
		install_name_tool -change "lib/libopencv_imgproc.3.0.dylib" "@executable_path/../Frameworks/libopencv_imgproc.dylib" ${i}
    install_name_tool -change "libOpenNI2.dylib" "@executable_path/../Frameworks/libOpenNI2.dylib" ${i}
        done

  	lib_path="${PWD}/${CS2_BASE}/cs2.app/Contents/prefix/usr/lib"
  	for i in $(ls -1 ${lib_path}/*.dylib)
          do
  		install_name_tool -change "/usr/local/lib/libzbar.0.dylib" "lib/libzbar.0.dylib" ${i}
      install_name_tool -change "lib/libopencv_core.3.0.dylib" "lib/libopencv_core.dylib" ${i}
      install_name_tool -change "lib/libopencv_highgui.3.0.dylib" "lib/libopencv_highgui.dylib" ${i}
      install_name_tool -change "lib/libopencv_imgproc.3.0.dylib" "lib/libopencv_imgproc.dylib" ${i}
      install_name_tool -change "libOpenNI2.dylib" "lib/libOpenNI2.dylib" ${i}
  	done
fi



############
# KISS IDE #
############

KISS_BASE="${PACKAGE}"
KISS_EXTRAS="${KISS_BASE}"

mkdir -p ${KISS_BASE}

# Mac OS X Bundle
if [[ ${OS_NAME} == "Darwin" ]]; then
	KISS_EXTRAS="${KISS_BASE}/KISS.app/Contents"
	# Install Base
	cp -r kiss/deploy/KISS.app ${KISS_BASE}
else
	# Install Base
	cp -r kiss/deploy/* ${KISS_BASE}
fi

mkdir -p ${KISS_EXTRAS}/docs
mkdir -p ${KISS_EXTRAS}/docs/libkovan
cp -r "link-docs/KIPR Link C Standard Library" ${KISS_EXTRAS}/docs/0_kipr_doc
cp -r libkovan/doc/* ${KISS_EXTRAS}/docs/libkovan



# These install the necessary shared libraries
kissarchive -e ${PCOMPILER_PACKAGE%.*} ${KISS_EXTRAS}
kissarchive -e ${LIBKOVANSERIAL_PACKAGE%.*} ${KISS_EXTRAS}
kissarchive -e ${LIBKAR_PACKAGE%.*} ${KISS_EXTRAS}

framework_path="${PWD}/${PACKAGE}/KISS.app/Contents/Frameworks"
for i in $(ls -1 ${framework_path}/*.dylib)
do
  echo "${i}"
  echo "${CMAKE_PREFIX_PATH}/lib/QtCore/Versions/5/QtCore"
install_name_tool -change "${CMAKE_PREFIX_PATH}/lib/QtCore.framework/Versions/5/QtCore" "@executable_path/../Frameworks/QtCore.framework/Versions/5/QtCore" ${i}
done
