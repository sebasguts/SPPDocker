#!/bin/bash -e

echo "installing Singular"

number_cores=$(cat /proc/cpuinfo | grep processor | wc -l)

cd /opt
sudo mkdir Singular
sudo chown -hR spp Singular
cd Singular
git clone https://github.com/Singular/Sources.git
cd Sources
git checkout $1
./autogen.sh
./configure --enable-gfanlib --with-flint=yes --with-gmp=$2
make -j${number_cores}
make check
sudo make install
