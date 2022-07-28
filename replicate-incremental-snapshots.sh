#!/bin/bash

# Create incremental snapshots of datasets in DATASETS array relative to their
# last full snapshot.

set -eux

# Change working directory to script directory.
cd "$(dirname "${BASH_SOURCE[0]}")"

. settings.sh

mkdir -p "${INCREMENTAL_SNAPSHOTS_DIR}"

TIMESTAMP="$(date -Iseconds | sed 's/://g' | sed 's/+0000/Z/g')"
readonly TIMESTAMP

# shellcheck disable=SC2153 # Not a misspelling
for DATASET in "${DATASETS[@]}"; do
  # Take a snapshot.
  INCREMENTAL_SNAPSHOT="${POOL}/${DATASET}@${TIMESTAMP}"
  zfs snapshot "${INCREMENTAL_SNAPSHOT}"

  # Find the most recent full snapshot.
  #  shellcheck disable=SC2012 # ls is better than find in this context
  BASE_SNAPSHOT_FILENAME="$(basename "$(ls -tr "${FULL_SNAPSHOTS_DIR}/${DATASET}"* | tail -1)")"
  if [[ -z "${BASE_SNAPSHOT_FILENAME}" ]]; then
    >&2 echo "Couldn't find full snapshot for dataset: ${DATASET}"
    exit 1
  fi
  BASE_SNAPSHOT="${POOL}/${BASE_SNAPSHOT_FILENAME}"

  # Write the incremental snapshot to a file.
  OUTPUT_FILENAME="${INCREMENTAL_SNAPSHOT//${POOL}\//}"
  OUTPUT_PATH="${INCREMENTAL_SNAPSHOTS_DIR}/${OUTPUT_FILENAME}"
  if [[ -f "${OUTPUT_PATH}" ]]; then
    echo "${OUTPUT_PATH} already exists, skipping..."
    continue
  fi
  zfs send --raw --verbose -i "${BASE_SNAPSHOT}" "${INCREMENTAL_SNAPSHOT}" \
    > "${OUTPUT_PATH}"
done

echo "Finished replicating incremental snapshots"
