#!/bin/sh

pushd libs/op/libs/boost/
curl -O http://assets.hookflash.me/github.com-openpeer-opios/lib/10012013_0.8_boost-build-iOS-5.zip
unzip 10012013_0.8_boost-build-iOS-5.zip
popd

pushd libs/op/libs/curl/
./build_ios.sh
popd
