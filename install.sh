#!/bin/bash

set -x
set -e

# export LDFLAGS
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib/x86_64-linux-gnu/:$LD_LIBRARY_PATH
echo "/usr/local/lib" >> /etc/ld.so.conf
#apt install -y g++ libprotobuf-dev protobuf-compiler protobuf-compiler-grpc libgrpc++-dev libgrpc-dev libtool automake autoconf cmake make pkg-config libyajl-dev zlib1g-dev libselinux1-dev libseccomp-dev libcap-dev libsystemd-dev git libarchive-dev libcurl4-gnutls-dev openssl libdevmapper-dev python3 libtar0 libtar-dev libhttp-parser-dev libwebsockets-dev

BUILD_DIR=/tmp/build_isulad

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

# build lxc
cd $BUILD_DIR
git clone https://github.com/xwen222/mirror_src-openeuler_lxc.git
git config --global --add safe.directory /tmp/build_isulad/mirror_src-openeuler_lxc/lxc-4.0.3
cd mirror_src-openeuler_lxc
./apply-patches
cd lxc-4.0.3
./autogen.sh
./configure
make -j $(nproc)
make install

# build lcr
cd $BUILD_DIR
git clone https://github.com/xwen222/mirror_openeuler_lcr.git
cd mirror_openeuler_lcr
mkdir build
cd build
cmake ..
make -j $(nproc)
make install

# build and install clibcni
cd $BUILD_DIR
git clone https://github.com/xwen222/mirror_openeuler_clibcni.git
cd mirror_openeuler_clibcni
mkdir build
cd build
cmake ..
make -j $(nproc)
make install

# build and install iSulad
cd $BUILD_DIR
git clone https://github.com/xwen222/mirror_openeuler_iSulad.git
cd mirror_openeuler_iSulad
mkdir build
cd build
cmake ..
make -j $(nproc)
make install

# clean
rm -rf $BUILD_DIR
apt autoremove
