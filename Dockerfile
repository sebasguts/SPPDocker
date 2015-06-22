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
                                   libmpfr-dev libcdd-dev libntl-dev git


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
RUN    cd /opt \
    && sudo wget http://www.4ti2.de/version_1.6.3/4ti2-1.6.3.tar.gz \
    && sudo tar -xf 4ti2-1.6.3.tar.gz \
    && sudo chown -hR spp 4ti2-1.6.3 \
    && sudo rm 4ti2-1.6.3.tar.gz \
    && cd 4ti2-1.6.3 \
    && ./configure \
    && make -j \
    && sudo make install

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
    && rm -rf InstPackages.sh \
    && sudo ln -sn /opt/gap4r7/bin/gap.sh /usr/local/bin/gap
