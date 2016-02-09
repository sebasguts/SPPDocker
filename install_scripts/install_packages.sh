#!/bin/bash -e

echo "Installing packages for ubuntu"

sudo apt-get -qq install -y \
    ant \
    ant-optional \
    autoconf \
    autogen \
    bliss \
    build-essential \
    bzip2 \
    clang \
    cmake \
    debhelper \
    default-jdk \
    g++ \
    git \
    graphviz \
    language-pack-en \
    libbliss-dev \
    libboost-dev \
    libcdd-dev \
    libdatetime-perl \
    libfplll-dev \
    libglpk-dev \
    libgmp-dev \
    libgmp3-dev \
    libgmpxx4ldbl \
    libmpc-dev \
    libmpfi-dev \
    libmpfr-dev \
    libncurses5-dev \
    libntl-dev \
    libperl-dev \
    libppl-dev \
    libreadline6-dev \
    libsvn-perl \
    libterm-readline-gnu-perl \
    libterm-readkey-perl \
    libtool \
    libxml-libxml-perl \
    libxml-libxslt-perl \
    libxml-perl \
    libxml-writer-perl \
    libxml2-dev \
    m4 \
    mercurial \
    mongodb \
    nano \
    screen \
    unzip \
    vim \
    w3c-dtd-xhtml \
    wget \
    xsltproc

sudo apt-get -qq clean -y
