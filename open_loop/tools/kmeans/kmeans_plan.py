"""Build command-conditioned planning anchors for the 3s and 6s configs."""

import argparse
from pathlib import Path

import mmcv
import numpy as np
from sklearn.cluster import KMeans


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--info", required=True, help="nuScenes training info pickle")
    parser.add_argument("--steps", type=int, required=True, choices=(6, 12))
    parser.add_argument("--clusters", type=int, default=6)
    parser.add_argument("--output", required=True)
    return parser.parse_args()


def main():
    args = parse_args()
    samples = [[], [], []]
    for info in mmcv.load(args.info)["infos"]:
        trajectory = np.asarray(info["gt_ego_fut_trajs"])
        mask = np.asarray(info["gt_ego_fut_masks"])
        if len(trajectory) < args.steps or mask[: args.steps].sum() != args.steps:
            continue
        command = int(np.asarray(info["gt_ego_fut_cmd"]).argmax())
        samples[command].append(trajectory[: args.steps].cumsum(axis=0))

    centers = []
    for command, trajectories in enumerate(samples):
        if len(trajectories) < args.clusters:
            raise ValueError(
                f"Command {command} has {len(trajectories)} valid trajectories; "
                f"at least {args.clusters} are required"
            )
        flat = np.asarray(trajectories).reshape(len(trajectories), -1)
        cluster = KMeans(n_clusters=args.clusters, random_state=0, n_init=10)
        centers.append(cluster.fit(flat).cluster_centers_.reshape(-1, args.steps, 2))

    output = Path(args.output)
    output.parent.mkdir(parents=True, exist_ok=True)
    np.save(str(output), np.stack(centers, axis=0).astype(np.float32))
    print(f"Saved {output}")


if __name__ == "__main__":
    main()
