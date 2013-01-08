#
#  Copyright 2012 KISS Institute for Practical Robotics
#
#  This file is part of the KISS Platform (Kipr's Instructional Software System).
#
#  The KISS Platform is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  The KISS Platform is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with the KISS Platform.  Check the LICENSE file in the project root.
#  If not, see <http://www.gnu.org/licenses/>.

#!/bin/sh

BUILD=build

build_autotools()
{
	local folder=$1
	local install=$2
	local options=$3
	local wd=${PWD}
	cd "${wd}/${folder}"
	echo "./configure ${options}"
	./configure ${options}
	if [ "$?" -ne "0" ]; then
		echo "cmake for ${1} failed."
		exit 1
	fi
	make -j4
	if [ "$?" -ne "0" ]; then
		echo "make for ${1} failed."
		exit 1
	fi
	
	if [[ "${install}" -eq "1" ]]; then
		make install
		if [ "$?" -ne "0" ]; then
			echo "make install for ${1} failed."
			exit 1
		fi
	fi
	cd "${wd}"
}

build_cmake()
{
	local folder=$1
	local install=$2
	local options=$3
	mkdir -p ${BUILD}/${folder}
	local wd=${PWD}
	cd ${BUILD}/${folder}
	if [[ $(uname -s) == MINGW* ]] ;
	then
		QTS=$(find /c/Qt/Desktop/Qt/* -maxdepth 0 | sort -rn)
		QTDIR=${QTS[0]}/mingw cmake ../..//${folder} -G "MSYS Makefiles" "-DDIRECTX=/c/Program Files/Microsoft DirectX SDK (June 2010)" ${options}
	else
		cmake ${wd}/${folder} ${options}
	fi
	if [ "$?" -ne "0" ]; then
		echo "cmake for ${1} failed."
		exit 1
	fi
	make -j4
	if [ "$?" -ne "0" ]; then
		echo "make for ${1} failed."
		exit 1
	fi
	
	if [[ "${install}" -eq "1" ]]; then
		make install
		if [ "$?" -ne "0" ]; then
			echo "make install for ${1} failed."
			exit 1
		fi
	fi
	cd -
}

build_make()
{
	local folder=$1
	local install=$2
	local options=$3
	local wd=${PWD}
	
	cd ${folder}
	make -j4 ${options}
	if [ "$?" -ne "0" ]; then
		echo "make for ${1} failed."
		exit 1
	fi
	
	if [[ "${install}" -eq "1" ]]; then
		make ${options} install
		if [ "$?" -ne "0" ]; then
			echo "make install for ${1} failed."
			exit 1
		fi
	fi
	cd ${wd}
}

mkdir -p build

#########################
# The Core Distribution #
#########################

build_cmake libkar 1
build_cmake pcompiler 1
build_cmake libkovanserial 1
build_cmake kiss 1
build_cmake computer
build_cmake ks2

############
# Packages #
############

build_cmake opencv 1 "-DWITH_FFMPEG=OFF -DCMAKE_INSTALL_PREFIX=${PWD}/opencv/kiss-prefix"
build_cmake blobtastic
build_cmake libkovan
build_autotools zbar-0.10 1 "--without-x --without-xshm --without-xv --without-imagemagick --without-gtk --without-qt --without-python --without-jpeg --disable-video --prefix=${PWD}/zbar-0.10/prefix"
build_cmake libkiss2