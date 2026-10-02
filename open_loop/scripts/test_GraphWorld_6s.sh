#!/usr/bin/env bash
set -euo pipefail

CHECKPOINT=${1:?Usage: bash scripts/test_GraphWorld_6s.sh CHECKPOINT [NUM_GPUS] [OUTPUT_PKL]}
NUM_GPUS=${2:-8}
OUTPUT_PKL=${3:-work_dirs/GraphWorld_small_stage2_6s/results.pkl}
mkdir -p "$(dirname "$OUTPUT_PKL")"

bash ./tools/dist_test.sh \
  projects/configs/GraphWorld_small_stage2_6s.py \
  "$CHECKPOINT" \
  "$NUM_GPUS" \
  --deterministic \
  --out "$OUTPUT_PKL" \
  --eval bbox
