#!/bin/sh

cd common

sh fetch.sh $@
sh build.sh $@
sh archive.sh $@
sh pre_package.sh $@

cd -

echo "Done!!!"