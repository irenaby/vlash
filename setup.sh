#!/usr/bin/env bash
set -ex

apt-get update && apt-get install -y wget vim

wget -O /tmp/Miniforge3-Linux-x86_64.sh \
  https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash /tmp/Miniforge3-Linux-x86_64.sh -b -p "$HOME/miniforge3"
export PATH="$HOME/miniforge3/bin:$PATH"
source "$HOME/miniforge3/etc/profile.d/conda.sh"

cd /dev/shm
git clone https://github.com/irenaby/vlash.git vlash_fork && cd vlash_fork && git checkout mylibero
conda env create -f ./conda_env.yaml
conda activate vlash
pip install -e .
pip install mujoco==3.3.7 numpy==1.24.4 || echo foo
sleep 5d
