#!/bin/bash

# Create full snapshots of datasets in DATASETS array.

set -eux

# Change working directory to script directory.
cd "$(dirname "${BASH_SOURCE[0]}")"

. settings.sh

mkdir -p "${FULL_SNAPSHOTS_DIR}"

TIMESTAMP="$(date -Iseconds | sed 's/://g' | sed 's/+0000/Z/g')"
readonly TIMESTAMP

# shellcheck disable=SC2153 # Not a misspelling
for DATASET in "${DATASETS[@]}"; do
  # Take a snapshot.
  SNAPSHOT_NAME="${POOL}/${DATASET}@${TIMESTAMP}"
  zfs snapshot "${SNAPSHOT_NAME}"

  # Write the snapshot to a file.
  OUTPUT_FILENAME="${SNAPSHOT_NAME//${POOL}\//}"
  zfs send --raw --verbose "${SNAPSHOT_NAME}" > "${FULL_SNAPSHOTS_DIR}/${OUTPUT_FILENAME}"
done

echo "Finished replicating full snapshots"
