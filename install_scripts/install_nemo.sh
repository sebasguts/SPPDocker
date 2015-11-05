#!/bin/bash -e

echo "installing nemo"

sudo apt-get install -y software-properties-common 
sudo apt-add-repository ppa:staticfloat/julianightlies
sudo apt-add-repository ppa:staticfloat/julia-deps
sudo apt-get -qq update
sudo apt-get install -y julia
julia <<EOF
Pkg.clone("https://github.com/wbhart/Nemo.jl")
Pkg.build("Nemo")
EOF
