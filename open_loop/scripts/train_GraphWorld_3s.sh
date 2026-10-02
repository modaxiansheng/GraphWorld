#!/usr/bin/env bash
set -euo pipefail

NUM_GPUS=${1:-8}
bash ./tools/dist_train.sh \
  projects/configs/GraphWorld_small_stage2.py \
  "$NUM_GPUS" \
  --deterministic
