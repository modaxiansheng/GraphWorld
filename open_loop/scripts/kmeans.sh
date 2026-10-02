#!/usr/bin/env bash
set -euo pipefail

mkdir -p data/kmeans vis/kmeans

python tools/kmeans/kmeans_det.py
python tools/kmeans/kmeans_map.py
python tools/kmeans/kmeans_motion.py
python tools/kmeans/kmeans_plan.py \
  --info data/infos/nuscenes_infos_train.pkl \
  --steps 6 --clusters 6 \
  --output data/kmeans/kmeans_plan_6.npy
