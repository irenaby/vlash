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

REPO_ROOT=/dev/shm
BRANCH=mykinetix

cd $REPO_ROOT
git clone https://github.com/irenaby/vlash.git vlash_fork && cd vlash_fork && git checkout $BRANCH
git submodule update --init --recursive
cd benchmarks/kinetix/third_party/kinetix
pip install -e .
cd ../..
pip uninstall -y jax jax-cuda12-pjrt jax-cuda12-plugin jaxlib
pip install jax==0.4.34 jax-cuda12-pjrt==0.4.34 jax-cuda12-plugin==0.4.34 jaxlib==0.4.34 flax

# there is a mismatch between the ckpt and the code
#hf download mit-han-lab/vlash-kinetix-policy-async5
#snapshots=/root/.cache/huggingface/hub/models--mit-han-lab--vlash-kinetix-policy-async5/snapshots
#ckpt_path=$snapshots/$(ls $snapshots)
#cd benchmarks/kinetix
#python src/eval_flow.py --run-path $ckpt_path --output-dir /outputs/eval_outputs

# download expert ckechpoints and kinetix trajectories it created or something like that ???
pip install gsutil
mkdir /app/data
gsutil -m rsync -r gs://rtc-assets/expert/ /app/data/

export WANDB_MODE=disabled
cd $REPO_ROOT/benchmark/kinetix
EXPERT_DATA=/app/data OUTDIR=/outputs N_GPUS=4 bash ../train_kinetix.sh > /outputs/train_vlash_kinetix.log 2>&1 &    # this is a modified copy of scripts/train.sh from benchmark/kinetix git submodule
pid=$!
wait $pid 

#pip install mujoco==3.3.7 numpy==1.24.4 || echo foo
sleep 5d

