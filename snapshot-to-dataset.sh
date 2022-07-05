#!/bin/bash

# Usage: ./snapshot-to-dataset.sh dataset new-dataset

set -eux

. settings.sh

TARGET_DATASET="$1"
NEW_DATASET="$2"

BASE_SNAPSHOT_PATH="$(ls -tr "${FULL_SNAPSHOTS_DIR}/${TARGET_DATASET}"* | tail -1)"
readonly BASE_SNAPSHOT_PATH

# TODO: Refacotr into lib.sh

LATEST_SNAPSHOT="$(zfs list -t snapshot -o name -s creation -r ${POOL}/${TARGET_DATASET} | tail -1)"
readonly LATEST_SNAPSHOT
LATEST_INCREMENTAL_SNAPSHOT_FILENAME="$(echo "${LATEST_SNAPSHOT}" | sed "s|${POOL}/||g")"
readonly LATEST_INCREMENTAL_SNAPSHOT_FILENAME
LATEST_INCREMENTAL_SNAPSHOT_PATH="${INCREMENTAL_SNAPSHOTS_DIR}/${LATEST_INCREMENTAL_SNAPSHOT_FILENAME}"
readonly LATEST_INCREMENTAL_SNAPSHOT_PATH

# Restore from base snapshot
zfs receive "${POOL}/${NEW_DATASET}" < "${BASE_SNAPSHOT_PATH}"

# Update dataset to latest incremental snapshot
zfs receive "${POOL}/${NEW_DATASET}" < "${LATEST_INCREMENTAL_SNAPSHOT_PATH}"
