#!/bin/bash -e

echo "installing gmp"

number_cores=$(cat /proc/cpuinfo | grep processor | wc -l)

cd /tmp
wget https://gmplib.org/download/gmp/$1
tar -xf $1
cd $2
mkdir $3
./configure --prefix=$3 --enable-cxx
make -j${number_cores}
make install
cd /tmp
rm -rf $1 $2
