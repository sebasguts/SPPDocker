## Dockerfile for the DFG SPP Computeralgebra Software

FROM ubuntu:trusty

MAINTAINER Sebastian Gutsche <sebastian.gutsche@gmail.com>

RUN apt-get update -qq \
    && adduser --quiet --shell /bin/bash --gecos "spp user,101,," --disabled-password spp \
    && adduser spp sudo \
    && chown -R spp:spp /home/spp/ \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER spp

ADD install_scripts /tmp/install_scripts

WORKDIR /tmp/install_scripts

RUN sudo chown -R spp:spp /tmp/install_scripts

RUN    chmod +x install_packages.sh \
    && ./install_packages.sh

ENV gmp_folder /home/spp/gmp

# Own GMP, 4ti2gap seems to have problems with ubuntu
RUN    chmod +x install_gmp.sh \
    && ./install_gmp.sh gmp-6.0.0a.tar.bz2 gmp-6.0.0 ${gmp_folder}

# Flint
RUN    chmod +x install_flint.sh \
    && ./install_flint.sh 5403ee61d5a76ef2af300082a6c3283b97cdf5d1 ${gmp_folder}

# Singular
RUN    chmod +x install_singular.sh \
    && ./install_singular.sh 08fd464d5e4df1154e463c07e5e6ba3e86a18200 ${gmp_folder}

# Polymake
RUN    chmod +x install_polymake.sh \
    && ./install_polymake.sh ${gmp_folder}

ENV FourTiTwo_shared_folder /home/spp/4ti2-shared

# 4ti2
RUN    chmod +x install_4ti2.sh \
    && ./install_4ti2.sh ${gmp_folder} ${FourTiTwo_shared_folder}

## Normaliz
RUN    chmod +x install_normaliz.sh \
    && ./install_normaliz.sh 082f1e01542111d28296550fd26e20a4aaf0d0d9 ${gmp_folder}

# GAP
RUN    chmod +x install_gap.sh \
    && ./install_gap.sh http://www.gap-system.org/pub/gap/gap47/tar.gz/gap4r7p8_2015_06_09-20_27.tar.gz ${gmp_folder}

# # Nemo
RUN    chmod +x install_nemo.sh \
    && ./install_nemo.sh

# Local package folder and workspace for GAP
RUN    chmod +x install_gap_options.sh \
    && ./install_gap_options

# GAP packages: homalg-project, SingularInterface, NormalizInterface, 4ti2gap
RUN    chmod +x install_gap_packages.sh \
    && ./install_gap_packages ${gmp_folder} ${FourTiTwo_shared_folder}

ENV HOME /home/spp
ENV PATH /home/spp/bin:$PATH
WORKDIR /home/spp

