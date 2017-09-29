## Dockerfile for the DFG SPP Computeralgebra Software

FROM ubuntu:trusty

MAINTAINER Sebastian Gutsche <sebastian.gutsche@gmail.com>

RUN apt-get update -qq \
    && adduser --quiet --shell /bin/bash --gecos "spp user,101,," --disabled-password spp \
    && adduser spp sudo \
    && chown -R spp:spp /home/spp/ \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER spp

ENV gmp_folder /home/spp/gmp
ENV FourTiTwo_shared_folder /home/spp/4ti2-shared

RUN    mkdir /tmp/install_scripts

## Starting installation

WORKDIR /tmp/install_scripts

# Required Ubuntu packages
ADD install_scripts/install_packages.sh /tmp/install_scripts/install_packages.sh
RUN sudo chmod a+x install_packages.sh \
    && ./install_packages.sh

# Own GMP, 4ti2gap seems to have problems with ubuntu
ADD install_scripts/install_gmp.sh /tmp/install_scripts/install_gmp.sh
RUN sudo chmod a+x install_gmp.sh \
    && ./install_gmp.sh gmp-6.1.2.tar.bz2 gmp-6.1.2 ${gmp_folder}

# Flint
ADD install_scripts/install_flint.sh /tmp/install_scripts/install_flint.sh
RUN sudo chmod a+x install_flint.sh \
    && ./install_flint.sh 61dc2ced48297c09fe3a501a0253251c4dc5acd9 ${gmp_folder}

# Singular
ADD install_scripts/install_singular.sh /tmp/install_scripts/install_singular.sh
RUN sudo chmod a+x install_singular.sh \
    && ./install_singular.sh b4e678f4ebbc2cbfb443db3205b1e086ba00bb4c ${gmp_folder}

# Polymake
ADD install_scripts/install_polymake.sh /tmp/install_scripts/install_polymake.sh
RUN sudo chmod a+x install_polymake.sh \
    && ./install_polymake.sh ${gmp_folder}

# 4ti2
ADD install_scripts/install_4ti2.sh /tmp/install_scripts/install_4ti2.sh
RUN sudo chmod a+x install_4ti2.sh \
    && ./install_4ti2.sh 1.6.7 ${gmp_folder} ${FourTiTwo_shared_folder}

## Normaliz
ADD install_scripts/install_normaliz.sh /tmp/install_scripts/install_normaliz.sh
RUN sudo chmod a+x install_normaliz.sh \
    && ./install_normaliz.sh e1c77b09d1308d6304160847267743d435c74abb ${gmp_folder}

# GAP
ADD install_scripts/install_gap.sh /tmp/install_scripts/install_gap.sh
RUN sudo chmod a+x install_gap.sh \
    && ./install_gap.sh https://www.gap-system.org/pub/gap/gap48/tar.gz/gap4r8p8_2017_08_20-15_12.tar.gz ${gmp_folder}

# # Nemo
ADD install_scripts/install_nemo.sh /tmp/install_scripts/install_nemo.sh
RUN sudo chmod a+x install_nemo.sh \
    && ./install_nemo.sh

# Local package folder and workspace for GAP
ADD install_scripts/install_gap_options.sh /tmp/install_scripts/install_gap_options.sh
RUN sudo chmod a+x install_gap_options.sh \
    && ./install_gap_options.sh

# GAP packages: homalg-project, SingularInterface, NormalizInterface, 4ti2gap
ADD install_scripts/install_gap_packages.sh /tmp/install_scripts/install_gap_packages.sh
RUN sudo chmod a+x install_gap_packages.sh \
    && ./install_gap_packages.sh ${gmp_folder} ${FourTiTwo_shared_folder}

## Installation complete, setting up user enviroment

ENV HOME /home/spp
ENV PATH /home/spp/bin:$PATH
WORKDIR /home/spp

