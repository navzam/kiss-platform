#!/bin/sh

ARCHIVE=kissarchive
ARCHIVES=archives
BUILD=build

OS_NAME=$(uname -s)

SUFFIX=""

# Mac OS X
if [[ OS_NAME -eq "Darwin" ]]; then
	SUFFIX="osx"
fi


archive()
{
	local package=$1
	local version=$2
	local extra=$3
	local extra_path=${4}
	local wd=${PWD}
	if [[ "${version}" -eq "git" ]]; then
		cd ${package}
		version=$(git rev-parse HEAD)
		cd ${wd}
	fi
	
	cd ${wd}/${package}${extra_path}
	kissarchive -c "${package}" "${version}" "${wd}/${ARCHIVES}/${package}${extra}_${SUFFIX}.kam"
	if [ "$?" -ne "0" ]; then
		echo "archive for ${1} failed."
		exit 1
	fi
	cp "${package}-${version}.kiss" "${wd}/${BUILD}/${package}${extra}-${version}.kiss"
	rm -f *.kiss
	cd ${wd}
}

rm -f ${BUILD}/*.kiss
mkdir -p ${PWD}/${BUILD}

#################
# Core Packages #
#################

archive libkar git
archive libkovanserial git
archive pcompiler git

############
# Packages #
############

archive blobtastic git
archive opencv git
archive libkiss2 git
archive libkovan git
archive libkovan git _host
archive zbar "10" _host "-0.10"