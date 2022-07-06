#!/bin/bash

set -eux

. settings.sh

mkdir -p "${INCREMENTAL_SNAPSHOTS_DIR}"

# shellcheck disable=SC2153 # Not a misspelling
for DATASET in "${DATASETS[@]}"; do
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
