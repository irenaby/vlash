#!/usr/bin/env bash
set -ex

apt-get update && apt-get install -y wget vim

wget -O /tmp/Miniforge3-Linux-x86_64.sh \
  https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash /tmp/Miniforge3-Linux-x86_64.sh -b -p "$HOME/miniforge3"
export PATH="$HOME/miniforge3/bin:$PATH"
source "$HOME/miniforge3/etc/profile.d/conda.sh"

conda create -n kinetix python==3.11
conda activate kinetix

cd /dev/shm
git clone https://github.com/irenaby/vlash.git vlash_fork && cd vlash_fork && git checkout mykinetix
git submodule update --init --recursive
cd benchmarks/kinetix/third_party/kinetix
pip install -e .
cd ../..
pip uninstall -y jax jax-cuda12-pjrt jax-cuda12-plugin jaxlib
pip install jax==0.4.34 jax-cuda12-pjrt==0.4.34 jax-cuda12-plugin==0.4.34 jaxlib==0.4.34 flax

hf download mit-han-lab/vlash-kinetix-policy-async5
snapshots=/root/.cache/huggingface/hub/models--mit-han-lab--vlash-kinetix-policy-async5/snapshots
ckpt_path=$snapshots/$(ls $snapshots)
cd benchmarks/kinetix
python src/eval_flow.py --run-path $ckpt_path --output-dir /outputs/eval_outputs

#pip install mujoco==3.3.7 numpy==1.24.4 || echo foo
sleep 5d

