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

mkdir /home/spp/extensions
cd /home/spp/extensions
git clone --depth 1 https://github.com/solros/poly_db.git
git clone --depth 1 https://github.com/apaffenholz/polymake_flint_wrapper.git
git clone --depth 1 https://github.com/apaffenholz/lattice_normalization.git
cd /home/spp/extensions
echo 'use application "common"; import_extension("/home/polymake/extensions/poly_db"); import_extension("/home/polymake/extensions/polymake_flint_wrapper","--with-flint=/usr/local"); import_extension("/home/polymake/extensions/lattice_normalization");' > import_ext.pl

cd /home/spp/extensions \	
script -c 'TERM=xterm polymake --iscript /home/polymake/extensions/import_ext.pl /dev/null'
rm import_ext.pl

polymake 'my $c=cube(3);'