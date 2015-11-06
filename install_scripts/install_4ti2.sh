#!/bin/bash -e

echo "installing 4ti2"

number_cores=$(cat /proc/cpuinfo | grep processor | wc -l)

VERSION=1.6.6

cd /tmp
wget http://www.4ti2.de/version_$VERSION/4ti2-$VERSION.tar.gz
tar -xf 4ti2-$VERSION.tar.gz
cd 4ti2-$VERSION
./configure --with-gmp=$1
make -j${number_cores}
sudo make install
cd /tmp
rm -rf 4ti2-$VERSION
tar -xf 4ti2-$VERSION.tar.gz
cd 4ti2-$VERSION
mkdir $2
./configure --prefix=$2 --enable-shared --with-gmp=$1
make -j${number_cores}
make install
cd /tmp
rm -rf 4ti2*
