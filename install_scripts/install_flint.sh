#!/bin/bash

echo "installing flint"

number_cores=$(cat /proc/cpuinfo | grep processor | wc -l)

cd /tmp
git clone https://github.com/wbhart/flint2.git
cd flint2
git checkout $1
./configure --with-gmp=$2
make -j4{number_cores}
sudo make install
cd /tmp
rm -rf flint2