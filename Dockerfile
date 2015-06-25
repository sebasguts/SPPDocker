## Dockerfile for the DFG SPP Computeralgebra Software

FROM ubuntu:utopic

MAINTAINER Sebastian Gutsche <sebastian.gutsche@gmail.com>

RUN apt-get update -qq \
    && adduser --quiet --shell /bin/bash --gecos "spp user,101,," --disabled-password spp \
    && adduser spp sudo \
    && chown -R spp:spp /home/spp/ \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER spp

## Install missing packages
RUN    sudo apt-get -qq install -y build-essential m4 libreadline6-dev \
                                   libncurses5-dev wget unzip libgmp3-dev \
                                   ant ant-optional g++ libboost-dev \
                                   libgmp-dev libgmpxx4ldbl libmpfr-dev libperl-dev \
                                   libsvn-perl libterm-readline-gnu-perl \
                                   libxml-libxml-perl libxml-libxslt-perl libxml-perl \
                                   libxml-writer-perl libxml2-dev w3c-dtd-xhtml xsltproc \
                                   bliss libbliss-dev \
                                   ## GAP stuff
                                   libmpfr-dev libmpfi-dev libmpc-dev libfplll-dev \
                                   ## Singular stuff
                                   autoconf autogen libtool libreadline6-dev libglpk-dev \
                                   libmpfr-dev libcdd-dev libntl-dev git mercurial cmake


# Flint
RUN    cd /tmp \
    && git clone https://github.com/wbhart/flint2.git \
    && cd flint2 \
    && ./configure \
    && make -j \
    && sudo make install \
    && cd /tmp \
    && rm -rf flint2

# Singular
RUN    cd /opt \
    && sudo mkdir Singular \
    && sudo chown -hR spp Singular \
    && cd Singular \
    && git clone https://github.com/Singular/Sources.git \
    && cd Sources \
    && ./autogen.sh \
    && ./configure --enable-gfanlib --with-flint=yes \
    && make -j \
    && make check \
    && sudo make install

# Polymake
RUN    cd /tmp \
    && wget http://www.polymake.org/lib/exe/fetch.php/download/polymake-2.14.tar.bz2 \
    && tar -xf polymake-2.14.tar.bz2 \
    && cd polymake-2.14 \\
    && ./configure --without-java --with-gmp=system \
    && make -j \
    && sudo make install \
    && cd /tmp \
    && rm -rf polymake*

# 4ti2
RUN    cd /tmp \
    && wget http://www.4ti2.de/version_1.6.6/4ti2-1.6.6.tar.gz \
    && tar -xf 4ti2-1.6.6.tar.gz \
    && cd 4ti2-1.6.6 \
    && ./configure --enable-shared \
    && make -j10 \
    && sudo make install \
    && cd /tmp \
    && rm -rf 4ti2*

## Normaliz
RUN    cd /tmp \
    && git clone https://github.com/Normaliz/Normaliz.git \
    && cd Normaliz \
    && mkdir BUILD \
    && cd BUILD \
    && cmake ../source \
    && make -j \
    && sudo make install \
    && cd /tmp \
    && rm -rf Normaliz

# GAP
RUN    cd /tmp \
    && wget http://www.gap-system.org/pub/gap/gap47/tar.gz/gap4r7p8_2015_06_09-20_27.tar.gz \
    && tar -xf gap*tar* \
    && rm -rf gap*tar* \
    && sudo mv gap4r7 /opt/ \
    && sudo chown -R spp /opt/gap4r7 \
    && cd /opt/gap4r7 \
    && ./configure --with-gmp=system \
    && make -j \
    && cd pkg \
    && wget https://raw.githubusercontent.com/gap-system/gap-docker/master/InstPackages.sh \
    && chmod +x InstPackages.sh \
    && ./InstPackages.sh \
    && rm -rf InstPackages.sh

# Local package folder and workspace for GAP
RUN    cd /opt/gap4r7 \
    && mkdir local \
    && cd local \
    && mkdir pkg \
    && sudo bash -c "echo '/opt/gap4r7/bin/gap.sh -l \"/opt/gap4r7/local;/opt/gap4r7\" \"\$@\"' > /usr/bin/gap" \
    && sudo chmod +x /usr/bin/gap \
    && sudo bash -c "echo '/opt/gap4r7/bin/gap.sh -l \"/opt/gap4r7/local;/opt/gap4r7\" -L /opt/gap4r7/bin/wsgap4 \"\$@\"' > /usr/bin/gapL" \
    && sudo chmod +x /usr/bin/gapL \
    && mkdir /home/spp/.gap \
    && echo 'SetUserPreference( "UseColorPrompt", true );' > /home/spp/.gap/gap.ini \
    && echo 'SetUserPreference( "UseColorsInTerminal", true );' > /home/spp/.gap/gap.ini \
    && echo 'SetUserPreference( "HistoryMaxLines", 10000 );' > /home/spp/.gap/gap.ini \
    && echo 'SetUserPreference( "SaveAndRestoreHistory", true );' > /home/spp/.gap/gap.ini \
    && cd /opt/gap4r7 \
    && wget http://www.gap-system.org/Download/CreateWorkspace.sh \
    && chmod +x CreateWorkspace.sh \
    && ./CreateWorkspace.sh \
    && rm CreateWorkspace.sh

# GAP packages: homalg-project, SingularInterface, NormalizInterface, 4ti2gap
RUN    cd /opt/gap4r7/local/pkg \
    && git clone https://github.com/fingolfin/NormalizInterface.git \
    && cd NormalizInterface \
    && ./autogen.sh \
    && ./configure --with-gaproot=/opt/gap4r7 --with-normaliz=/usr/local \
    && make \
    && cd /opt/gap4r7/local/pkg \
    && hg clone https://sebasguts@bitbucket.org/gap-system/4ti2gap \
#     && cd 4ti2gap \
#     && ./autogen.sh \
#     && ./configure --with-gaproot=/opt/gap4r7 --with-4ti2=/usr/local --with-gmp=yes \
#     && make \
#     && cd /opt/gap4r7/local/pkg
    && git clone https://github.com/gap-system/SingularInterface.git \
    && cd SingularInterface \
    && ./autogen.sh \
    && ./configure --with-gaproot=/opt/gap4r7 --with-libSingular=/usr/local \
    && make \
    && cd /opt/gap4r7/local/pkg \
    && export homalg_modules="AlgebraicThomas AbelianSystems alexander AutoDoc Blocks Conley D-Modules \
                              k-Points LessGenerators LetterPlace SCO SCSCP_ForHomalg Sheaves SimplicialObjects \
                              SystemTheory VirtualCAS CombinatoricsForHomalg CAP PrimaryDecomposition homalg_project" \
    && for i in $homalg_modules; do git clone https://github.com/homalg-project/${i}.git; done \
    && cd homalg_project/Gauss \
    && ./configure /opt/gap4r7 \
    && make \
    && cd ../PolymakeInterface \
    && ./configure /opt/gap4r7 \
    && make

ENV HOME /home/spp
WORKDIR /home/spp

