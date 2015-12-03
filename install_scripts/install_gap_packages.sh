#!/bin/bash -e

echo "installing gap packages"

number_cores=$(cat /proc/cpuinfo | grep processor | wc -l)

GAP_PKG_DIR=/opt/gap/local/pkg

# NormalizInterface
cd $GAP_PKG_DIR
git clone https://github.com/fingolfin/NormalizInterface.git
cd NormalizInterface
git clone https://github.com/normaliz/Normaliz Normaliz.git
./build-normaliz.sh
./autogen.sh
./configure --with-gaproot=/opt/gap --with-normaliz=$PWD/Normaliz.git/DST --with-gmp=$1
make

# 4ti2gap
cd $GAP_PKG_DIR
hg clone https://bitbucket.org/gap-system/4ti2gap
cd 4ti2gap
./autogen.sh
./configure --with-gaproot=/opt/gap --with-4ti2=$2 --with-gmp=$1
make

# SingularInterface
cd $GAP_PKG_DIR
git clone https://github.com/gap-system/SingularInterface.git
cd SingularInterface
./autogen.sh
./configure --with-gaproot=/opt/gap --with-libSingular=/usr/local
make

# Homalg
cd $GAP_PKG_DIR
export homalg_modules="AlgebraicThomas AbelianSystems alexander AutoDoc Blocks Conley D-Modules \
                       k-Points LessGenerators LetterPlace SCSCP_ForHomalg Sheaves SimplicialObjects \
                       SystemTheory VirtualCAS CombinatoricsForHomalg CAP_project PrimaryDecomposition SingularForHomalg homalg_project"
for i in $homalg_modules; do git clone https://github.com/homalg-project/${i}.git; done
cd homalg_project/Gauss
./configure /opt/gap
make
cd ../PolymakeInterface
./configure /opt/gap
make

# create documentation
cd $GAP_PKG_DIR
for i in $homalg_modules; do
  cd $i
  make doc
  cd ..
done

# More packages
cd $GAP_PKG_DIR
git clone https://github.com/martin-leuner/alcove.git
hg clone https://bitbucket.org/gap-system/numericalsgps
git clone https://github.com/homalg-project/homalg_starter.git
cd homalg_starter
mkdir /home/spp/bin
echo 'export homalg_project_modules="4ti2Interface Convex ExamplesForHomalg Gauss GaussForHomalg GradedModules GradedRingForHomalg HomalgToCAS IO_ForHomalg LocalizeRingForHomalg MatricesForHomalg Modules RingsForHomalg SCO ToolsForHomalg ToricVarieties homalg"' > init_homalg_starter
echo 'export extra_modules="alcove AbelianSystems AutoDoc D-Modules SCSCP_ForHomalg Sheaves SimplicialObjects SystemTheory alexander k-Points Conley alexander LetterPlace CombinatoricsForHomalg"' >> init_homalg_starter
echo 'export gap_bin=gap' >> init_homalg_starter
echo 'export package_directory=/opt/gap/local/pkg' >> init_homalg_starter
echo 'export start_script=/home/spp/bin/Autogap' >> init_homalg_starter
echo 'export start_script_git=/home/spp/bin/autogap' >> init_homalg_starter
chmod +x init_homalg_starter
./create_homalg_starter
./create_homalg_starter_git
/home/spp/bin/autogap < /dev/null
/home/spp/bin/Autogap < /dev/null
