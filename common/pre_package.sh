#!/bin/sh

ARCHIVE=kissarchive
BUILD=build
PACKAGE=package

OS_NAME=$(uname -s)

rm -Rf ${PACKAGE}
mkdir -p ${PACKAGE}

PCOMPILER_PACKAGE=$(ls ${BUILD}/pcompiler-*)
LIBKAR_PACKAGE=$(ls ${BUILD}/libkar-*)

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

OPENCV_PACKAGE=$(ls ${BUILD}/opencv-*)
BLOBTASTIC_PACKAGE=$(ls ${BUILD}/blobtastic-*)
LIBKISS2_PACKAGE=$(ls ${BUILD}/libkiss2-*)

kissarchive -e ${OPENCV_PACKAGE%.*} ${COMPUTER_EXTRAS}/prefix
kissarchive -e ${BLOBTASTIC_PACKAGE%.*} ${COMPUTER_EXTRAS}/prefix
kissarchive -e ${LIBKISS2_PACKAGE%.*} ${COMPUTER_EXTRAS}/prefix

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
kissarchive -e ${LIBKAR_PACKAGE%.*} ${KISS_EXTRAS}
