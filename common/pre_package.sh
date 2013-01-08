#!/bin/sh

ARCHIVE=kissarchive
BUILD=build
PACKAGE=package

OS_NAME=$(uname -s)

rm -Rf ${PACKAGE}
mkdir -p ${PACKAGE}

PCOMPILER_PACKAGE=$(ls ${BUILD}/pcompiler-*)
LIBKOVANSERIAL_PACKAGE=$(ls ${BUILD}/libkovanserial-*)
LIBKAR_PACKAGE=$(ls ${BUILD}/libkar-*)
OPENCV_PACKAGE=$(ls ${BUILD}/opencv-*)

############
# Computer #
############

COMPUTER_BASE="${PACKAGE}/computer"
COMPUTER_EXTRAS="${COMPUTER_BASE}"

# Mac OS X Bundle
if [[ OS_NAME -eq "Darwin" ]]; then
	COMPUTER_EXTRAS="${COMPUTER_BASE}/computer.app/Contents"
fi

# Install Base
mkdir -p ${COMPUTER_BASE}
cp -r computer/deploy/* ${COMPUTER_BASE}

# These install the necessary shared libraries
kissarchive -e ${PCOMPILER_PACKAGE%.*} ${COMPUTER_EXTRAS}
kissarchive -e ${LIBKAR_PACKAGE%.*} ${COMPUTER_EXTRAS}

BLOBTASTIC_PACKAGE=$(ls ${BUILD}/blobtastic-*)
LIBKISS2_PACKAGE=$(ls ${BUILD}/libkiss2-*)

kissarchive -e ${OPENCV_PACKAGE%.*} ${COMPUTER_EXTRAS}/prefix
kissarchive -e ${BLOBTASTIC_PACKAGE%.*} ${COMPUTER_EXTRAS}/prefix
kissarchive -e ${LIBKISS2_PACKAGE%.*} ${COMPUTER_EXTRAS}/prefix

###########
#   ks2   #
###########

KS2_BASE="${PACKAGE}/ks2"
KS2_EXTRAS="${KS2_BASE}"

# Mac OS X Bundle
if [[ OS_NAME -eq "Darwin" ]]; then
	KS2_EXTRAS="${KS2_BASE}/ks2.app/Contents"
fi

# Install Base
mkdir -p ${KS2_BASE}
cp -r ks2/deploy/* ${KS2_BASE}

# These install the necessary shared libraries
LIBKOVAN_PACKAGE=$(ls ${BUILD}/libkovan-*)
LIBKOVAN_HOST_PACKAGE=$(ls ${BUILD}/libkovan_host-*)
kissarchive -e ${PCOMPILER_PACKAGE%.*} ${KS2_EXTRAS}
kissarchive -e ${LIBKAR_PACKAGE%.*} ${KS2_EXTRAS}
kissarchive -e ${LIBKOVANSERIAL_PACKAGE%.*} ${KS2_EXTRAS}
kissarchive -e ${LIBKOVAN_HOST_PACKAGE%.*} ${KS2_EXTRAS}
kissarchive -e ${LIBKOVAN_PACKAGE%.*} ${KS2_EXTRAS}/prefix
kissarchive -e ${OPENCV_PACKAGE%.*} ${KS2_EXTRAS}/prefix

############
# KISS IDE #
############

KISS_BASE="${PACKAGE}/KISS"
KISS_EXTRAS="${KISS_BASE}"

mkdir -p ${KISS_BASE}

# Mac OS X Bundle
if [[ OS_NAME -eq "Darwin" ]]; then
	KISS_EXTRAS="${KISS_BASE}/KISS.app/Contents"
	# Install Base
	cp -r kiss/deploy/KISS.app ${KISS_BASE}
else
	# Install Base
	cp -r kiss/deploy/* ${KISS_BASE}
fi

# These install the necessary shared libraries
kissarchive -e ${PCOMPILER_PACKAGE%.*} ${KISS_EXTRAS}
kissarchive -e ${LIBKOVANSERIAL_PACKAGE%.*} ${KISS_EXTRAS}
kissarchive -e ${LIBKAR_PACKAGE%.*} ${KISS_EXTRAS}
