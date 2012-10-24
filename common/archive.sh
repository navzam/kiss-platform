#!/bin/sh

ARCHIVE=kissarchive
ARCHIVES=archives
BUILD=build

archive()
{
	local package=$1
	local version=$2
	local wd=${PWD}
	if [[ "${version}" -eq "git" ]]; then
		cd ${package}
		version=$(git rev-parse HEAD)
		cd ${wd}
	fi
	
	cd ${wd}/${package}
	kissarchive -c "${package}" "${version}" "${wd}/${ARCHIVES}/${package}.kam"
	if [ "$?" -ne "0" ]; then
		echo "archive for ${1} failed."
		exit 1
	fi
	cp "${package}-${version}.kiss" ${wd}/${BUILD}
	rm -f *.kiss
	cd ${wd}
}

rm -f ${BUILD}/*.kiss
mkdir -p ${PWD}/${BUILD}

#################
# Core Packages #
#################

archive libkar git
archive pcompiler git

############
# Packages #
############

archive blobtastic git
archive opencv git
archive libkiss2 git