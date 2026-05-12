#!/usr/bin/env bash
set -ex

apt-get update && apt-get install -y wget vim less

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


mkdir -p /root/.libero
cat > /root/.libero/config.yaml <<'EOF'
assets: /root/miniforge3/envs/vlash/lib/python3.10/site-packages/libero/libero/./assets
bddl_files: /root/miniforge3/envs/vlash/lib/python3.10/site-packages/libero/libero/./bddl_files
benchmark_root: /root/miniforge3/envs/vlash/lib/python3.10/site-packages/libero/libero
datasets: /root/miniforge3/envs/vlash/lib/python3.10/site-packages/libero/libero/../datasets
init_states: /root/miniforge3/envs/vlash/lib/python3.10/site-packages/libero/libero/./init_files
EOF

cd /dev/shm/vlash_fork
#export HF_TOKEN=<TOKEN>
#DETERMINISTIC_ENABLED=true N_ACTION_STEPS=5 DELAYS="0 1 2 3 4" NUM_GPUS=8 COMPILE=true bash libero-eval-scripts/run.sh > /outputs/vlash_libero_determ_actionsteps5_delay0-4.t 2>&1 &
#pid=$!
#wait $pid

sleep 5d
