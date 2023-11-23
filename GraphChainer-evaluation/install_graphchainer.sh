#!/bin/bash

# from https://github.com/algbio/GraphChainer readme

git clone https://github.com/algbio/GraphChainer.git GraphChainer
cd GraphChainer
git submodule update --init --recursive
mamba env create -f CondaEnvironment.yml
conda activate GraphChainer
make bin/GraphChainer

