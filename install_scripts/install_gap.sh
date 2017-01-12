#!/bin/bash -e

echo "installing gap"

number_cores=$(cat /proc/cpuinfo | grep processor | wc -l)

cd /tmp
wget $1
mkdir gap
tar -xf gap*tar* --strip-components=1 -C gap
rm -rf gap*tar*
sudo mv gap /opt/
sudo chown -R spp /opt/gap
cd /opt/gap
./configure --with-gmp=$2
make -j${number_cores}
./makepkgs
