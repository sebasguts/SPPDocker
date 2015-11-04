#!/bin/bash

echo "installing 4ti2"

number_cores=$(cat /proc/cpuinfo | grep processor | wc -l)

cd /tmp
wget http://www.4ti2.de/version_1.6.6/4ti2-1.6.6.tar.gz
tar -xf 4ti2-1.6.6.tar.gz
cd 4ti2-1.6.6
./configure --with-gmp=$1
make -j${number_cores}
sudo make install
cd /tmp
rm -rf 4ti2-1.6.6
tar -xf 4ti2-1.6.6.tar.gz
cd 4ti2-1.6.6
mkdir $2
./configure --prefix=$2 --enable-shared --with-gmp=$1
make -j${number_cores}
make install
cd /tmp
rm -rf 4ti2*
