#!/bin/bash -e

echo "installing Normaliz"

number_cores=$(cat /proc/cpuinfo | grep processor | wc -l)

cd /tmp
git clone https://github.com/Normaliz/Normaliz.git
cd Normaliz
git checkout $1
mkdir BUILD
cd BUILD
GMP_DIR=$2 cmake ../source
make -j${number_cores}
sudo make install
cd /tmp
rm -rf Normaliz
