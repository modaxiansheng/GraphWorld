#!/usr/bin/env bash
set -euo pipefail

RESULTS=${1:?Usage: bash scripts/visualize.sh RESULTS.pkl [OUTPUT_DIR] [3s|6s]}
OUTPUT_DIR=${2:-vis_GraphWorld}
HORIZON=${3:-6s}

case "$HORIZON" in
  3s) CONFIG=projects/configs/GraphWorld_small_stage2.py ;;
  6s) CONFIG=projects/configs/GraphWorld_small_stage2_6s.py ;;
  *) echo "Horizon must be 3s or 6s" >&2; exit 2 ;;
esac

export PYTHONPATH="$(dirname "$0")/..:${PYTHONPATH:-}"
python tools/visualization/visualize.py \
  "$CONFIG" \
  --result-path "$RESULTS" \
  --out-dir "$OUTPUT_DIR"
