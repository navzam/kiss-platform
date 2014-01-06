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
		echo "${GIT} pull -q"
		${GIT} pull -q
		cd ${wd}
	fi
	if [ "$?" -ne "0" ]; then
		echo "Updating git repository ${1} failed."
		exit 1
	fi
	echo "${2} is now up-to-date."
}

update_tar()
{
	local repo=$1
	local name=$2
	if [ ! -d ${2}* ]; then
		wget "${repo}"
		if [ "$?" -ne "0" ]; then
			echo "Updating tar repository ${repo} failed."
			exit 1
		fi
		tar xf ${name}*.tar*
		if [ "$?" -ne "0" ]; then
			echo "Updating tar repository ${repo} failed."
			exit 1
		fi
		rm -f "${name}*.tar*"
		
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
update_git git://github.com/kipr/cs2.git cs2

############
# Packages #
############

update_tar http://downloads.sourceforge.net/project/zbar/zbar/0.10/zbar-0.10.tar.bz2 zbar-0.10
update_git git://github.com/kipr/libkovan.git libkovan
update_git git://github.com/Itseez/opencv opencv
update_git git://github.com/kipr/link-docs.git link-docs
