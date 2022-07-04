readonly POOL="pool1"
readonly BASE_DIR="/mnt/${POOL}/encrypted-backups"
readonly FULL_SNAPSHOTS_DIR="${BASE_DIR}/full-snapshots"
readonly INCREMENTAL_SNAPSHOTS_DIR="${BASE_DIR}/incremental-snapshots"

DATASETS=()
DATASETS+=("documents")
DATASETS+=("music")
DATASETS+=("emails")
readonly DATASETS
