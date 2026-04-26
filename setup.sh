#!/usr/bin/env bash
set -ex

apt-get update && apt-get install -y wget vim

wget -O /tmp/Miniforge3-Linux-x86_64.sh \
  https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash /tmp/Miniforge3-Linux-x86_64.sh -b -p "$HOME/miniforge3"
export PATH="$HOME/miniforge3/bin:$PATH"
source "$HOME/miniforge3/etc/profile.d/conda.sh"

conda env create -f /app/conda_env_full.yml
conda activate vlash
pip install torch==2.7.1 tochvision==0.22.1 --index-url https://download.pytorch.org/whl/cu126
cd /dev/shm
git clone https://github.com/irenaby/vlash.git vlash_fork && cd vlash_fork && git checkout mylibero

pip install -e .

sleep 5d
