#!/bin/bash

# Create full snapshots of datasets in DATASETS array.

set -eux

# Change working directory to script directory.
cd "$(dirname "${BASH_SOURCE[0]}")"

. settings.sh

mkdir -p "${FULL_SNAPSHOTS_DIR}"

# shellcheck disable=SC2153 # Not a misspelling
for DATASET in "${DATASETS[@]}"; do
  LATEST_SNAPSHOT="$(zfs list -t snapshot -o name -s creation -r "${POOL}"/"${DATASET}" | tail -1)"
  OUTPUT_FILENAME="${LATEST_SNAPSHOT//${POOL}\//}"
  zfs send --raw --verbose "${LATEST_SNAPSHOT}" > "${FULL_SNAPSHOTS_DIR}/${OUTPUT_FILENAME}"
done
