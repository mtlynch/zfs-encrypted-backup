# zfs-encrypted-backup

Example scripts to demonstrate how to back up encrypted ZFS backups to an unencrypted dataset.

## Setup

1. Copy `settings.example.sh` to `settings.sh`
1. Customize the values in `settings.sh` according to your system.

## Perform a full backup

```bash
./replicate-full-snapshots.sh
```

## Perform an incremental backup

```bash
./replicate-incremental-snapshots.sh
```

## Restore from backup

```bash
./snapshot-to-dataset.sh
```
