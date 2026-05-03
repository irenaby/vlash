#!/bin/bash

set -eux

# modified benchmark/kinetix/scripts/train.sh (benchmark/kinetix is a submodule)

# Train flow policy with async delay augmentation

: "${N_GPUS:=4}"
: "${EXPERT_DATA:=/app/data}"
: "${ASYNC_INTERVAL:=5}"

default_outdir=/outputs/train_vlash_kinetix_async${ASYNC_INTERVAL}_gpus${N_GPUS}
: "${OUTDIR:=$default_outdir}"

export NCCL_NET_MERGE_LEVEL=LOC
export NCCL_P2P_DISABLE=1
export NCCL_IB_DISABLE=1
export NCCL_DEBUG=WARN

export CUDA_VISIBLE_DEVICES=$(seq -s, 0 $((N_GPUS-1)))

python src/train_flow.py \
    --config.run-path $EXPERT_DATA \
    --config.async-interval $ASYNC_INTERVAL \
    --config.output-dir $OUTDIR
