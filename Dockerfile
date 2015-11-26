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

ADD install_scripts /tmp/install_scripts
RUN    sudo chown -R spp:spp /tmp/install_scripts \
    && chmod +x /tmp/install_scripts/install_*.sh

## Starting installation

WORKDIR /tmp/install_scripts

# Required Ubuntu packages
RUN ./install_packages.sh

# Own GMP, 4ti2gap seems to have problems with ubuntu
RUN ./install_gmp.sh gmp-6.0.0a.tar.bz2 gmp-6.0.0 ${gmp_folder}

# Flint
RUN ./install_flint.sh 5403ee61d5a76ef2af300082a6c3283b97cdf5d1 ${gmp_folder}

# Singular
RUN ./install_singular.sh 08fd464d5e4df1154e463c07e5e6ba3e86a18200 ${gmp_folder}

# Polymake
RUN ./install_polymake.sh ${gmp_folder}

# 4ti2
RUN ./install_4ti2.sh 1.6.6 ${gmp_folder} ${FourTiTwo_shared_folder}

## Normaliz
RUN ./install_normaliz.sh 082f1e01542111d28296550fd26e20a4aaf0d0d9 ${gmp_folder}

# GAP
RUN ./install_gap.sh http://www.gap-system.org/pub/gap/gap48/beta/gap4r8p0_2015_11_01-13_28.tar.gz ${gmp_folder}

# # Nemo
RUN ./install_nemo.sh

# Local package folder and workspace for GAP
RUN ./install_gap_options.sh

# GAP packages: homalg-project, SingularInterface, NormalizInterface, 4ti2gap
RUN ./install_gap_packages.sh ${gmp_folder} ${FourTiTwo_shared_folder}

## Installation complete, setting up user enviroment

ENV HOME /home/spp
ENV PATH /home/spp/bin:$PATH
WORKDIR /home/spp

