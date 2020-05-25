#!/bin/bash

mkdir -p /workspace/tmwa-gitpod/.legacy
cd /workspace/tmwa-gitpod/.legacy

# clone all of our other repos
git clone --recursive https://github.com/themanaworld/tmwa-server-data.git --origin upstream
git clone --recursive https://github.com/themanaworld/tmwa.git --origin upstream

# symlink our repos
ln -s /workspace/tmwa-gitpod/.legacy/tmwa-server-data/tools /workspace/tmwa-gitpod/.legacy/tmw-tools
ln -s /workspace/tmwa-gitpod/.legacy/tmwa-server-data/client-data /workspace/tmwa-gitpod/.legacy/tmwa-client-data

# prepare for tmwa
mkdir -p ${GITPOD_REPO_ROOT}/.local/{bin,etc,include,lib,share,var}

# build tmwa
pushd tmwa
export LD_LIBRARY_PATH="${GITPOD_REPO_ROOT}/.local/lib"
#./configure --dev --prefix="${GITPOD_REPO_ROOT}/.local" # FIXME <
./configure --enable-debug --prefix="${GITPOD_REPO_ROOT}/.local"
make
make install
popd

# configure server-data
pushd tmwa-server-data
make conf
popd

# set up the dotfiles
. /workspace/tmwa-gitpod/scripts/dotfiles.sh
