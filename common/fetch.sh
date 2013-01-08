#!/bin/sh

GIT=git
HG=hg
SVN=svn

update_git()
{
	local repo=$1
	local name=$2
	if [ ! -d $2 ]; then
		${GIT} clone ${1}
	else
		local wd=${PWD}
		cd "$2"
		${GIT} pull -q
		cd ${wd}
	fi
	if [ "$?" -ne "0" ]; then
		echo "Updating git repository ${1} failed."
		exit 1
	fi
	echo "${2} is now up-to-date."
}

update_svn()
{
	local repo=$1
	local name=$2
	if [ ! -d $2 ]; then
		${SVN} co ${1}
	else
		local wd=${PWD}
		cd "$2"
		${SVN} up
		cd ${wd}
	fi
	if [ "$?" -ne "0" ]; then
		echo "Updating svn repository ${1} failed."
		exit 1
	fi
	echo "${2} is now up-to-date."
}

#########################
# The Core Distribution #
#########################

update_git git://github.com/kipr/libkar.git libkar
update_git git://github.com/kipr/pcompiler.git pcompiler
update_git git://github.com/kipr/libkovanserial.git libkovanserial
update_git git://github.com/kipr/kiss.git kiss
update_git git://github.com/kipr/computer.git computer

############
# Packages #
############

update_git git://github.com/kipr/blobtastic.git blobtastic
update_git git://github.com/kipr/libkiss2.git libkiss2
update_git git://code.opencv.org/opencv.git opencv
