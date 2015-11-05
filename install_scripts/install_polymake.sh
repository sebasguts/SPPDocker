#!/bin/bash -e

echo "installing polymake"

number_cores=$(cat /proc/cpuinfo | grep processor | wc -l)

cd /tmp
git clone --branch Snapshots --depth 1 https://github.com/polymake/polymake.git polymake-beta
cd polymake-beta
./configure --without-java --without-jreality --without-javaview --with-gmp=$1
make -j${number_cores}
sudo make install
cd /tmp
rm -rf polymake*
