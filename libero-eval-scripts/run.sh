#!/usr/bin/env bash
set -euo pipefail
set -x

: "${POLICY_PATH:=mit-han-lab/vlash-pi05-libero-async5}"
: "${NUM_GPUS:=8}"
: "${N_EPISODES:=500}"
: "${BATCH_SIZE:=32}"
: "${N_ACTION_STEPS:=5}"
: "${SEED:=42}"
: "${SUITES:=libero_spatial libero_object libero_goal libero_10}"
: "${COMPILE:=true}"
: "${DELAYS:=0 1 2 3 4}"
read -r -a N_ACTION_STEPS <<< "$N_ACTION_STEPS"
read -r -a SUITES <<< "$SUITES"
read -r -a DELAYS <<< "$DELAYS"

export MUJOCO_GL=egl
export CUDA_VISIBLE_DEVICES=$(seq -s, 0 $((NUM_GPUS-1)))
export TOKENIZERS_PARALLELISM=false



for suite in "${SUITES[@]}"; do
  for act_steps in "${N_ACTION_STEPS[@]}"; do
    for async_delay in "${DELAYS[@]}"; do
      out="/outputs/eval/pi05_async_libero/${suite}/async_delay${async_delay}_actions${act_steps}_gpu${NUM_GPUS}_b${BATCH_SIZE}_compile${COMPILE}/vlash"
      echo "[RUN] suite=${suite} async_delay=${async_delay} -> ${out}"

      python -m vlash.cli eval-libero \
        --policy.path="${POLICY_PATH}" \
        --output_dir="${out}" \
        --env.type=libero --env.task="${suite}" \
        --eval.n_episodes="${N_EPISODES}" --eval.batch_size="${BATCH_SIZE}" --eval.use_async_envs=True \
        --policy.device=cuda --policy.use_amp=false --policy.n_action_steps="${act_steps}" --policy.compile_model="${COMPILE}" \
        --eval.async_delay="${async_delay}" --eval.method_type=vlash \
        --seed="${SEED}" \
        --num_gpus="${NUM_GPUS}"
    done  
  done
done


