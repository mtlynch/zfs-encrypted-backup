#!/bin/bash

set -eux

source settings.sh

mkdir -p "${FULL_SNAPSHOTS_DIR}"

for DATASET in "${DATASETS[@]}"; do
  LATEST_SNAPSHOT="$(zfs list -t snapshot -o name -s creation -r "${POOL}"/"${DATASET}" | tail -1)"
  OUTPUT_FILENAME="$(echo "${LATEST_SNAPSHOT}" | sed "s|${POOL}/||g")"
  zfs send --raw --verbose "${LATEST_SNAPSHOT}" > "${FULL_SNAPSHOTS_DIR}/${OUTPUT_FILENAME}"
done
