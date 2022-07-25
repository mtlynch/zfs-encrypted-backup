#!/bin/bash

# Create incremental snapshots of datasets in DATASETS array relative to their
# last full snapshot.

set -eux

# Change working directory to script directory.
cd "$(dirname "${BASH_SOURCE[0]}")"

. settings.sh

mkdir -p "${INCREMENTAL_SNAPSHOTS_DIR}"

# shellcheck disable=SC2153 # Not a misspelling
for DATASET in "${DATASETS[@]}"; do
  #  shellcheck disable=SC2012 # ls is better than find in this context
  BASE_SNAPSHOT_FILENAME="$(basename "$(ls -tr "${FULL_SNAPSHOTS_DIR}/${DATASET}"* | tail -1)")"
  BASE_SNAPSHOT="${POOL}/${BASE_SNAPSHOT_FILENAME}"
  LATEST_SNAPSHOT="$(zfs list -t snapshot -o name -s creation -r "${POOL}"/"${DATASET}" | tail -1)"
  OUTPUT_FILENAME="${LATEST_SNAPSHOT//${POOL}\//}"
  OUTPUT_PATH="${INCREMENTAL_SNAPSHOTS_DIR}/${OUTPUT_FILENAME}"
  if [[ -f "${OUTPUT_PATH}" ]]; then
    echo "${OUTPUT_PATH} already exists, skipping..."
    continue
  fi
  zfs send --raw --verbose -i "${BASE_SNAPSHOT}" "${LATEST_SNAPSHOT}" \
    > "${OUTPUT_PATH}"
done
