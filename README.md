# zfs-encrypted-backup

[![CircleCI](https://circleci.com/gh/mtlynch/zfs-encrypted-backup.svg?style=svg)](https://circleci.com/gh/mtlynch/zfs-encrypted-backup)
[![License](https://img.shields.io/badge/license-Unlicense-blue)](LICENSE)

## Overview

Example scripts to demonstrate how to back up encrypted ZFS backups to an unencrypted dataset.

## Setup

1. Copy `settings.example.sh` to `settings.sh`
1. Customize the values in `settings.sh` according to your system.

## Perform a full backup

To perform a full backup of your dataset snapshots, run the following script:

```bash
./replicate-full-snapshots
```

You'll likely want to run this as a cron job weekly or monthly.

## Perform an incremental backup

To perform incremental backups relative to your latest full backups (above), run the following command:

```bash
./replicate-incremental-snapshots
```

You'll likely want to run this as a cron job daily or weekly.

## Restore from backup

To recover from an encrypted dataset backup, run the following script:

```bash
./snapshot-to-dataset \
  new-dataset-name \
  full-snapshot-path \
  [incremental-snapshot-path]
```

For example, if you were recovering a dataset from encrypted and incremental backup files, you'd run the following:

```bash
./snapshot-to-dataset \
  documents-recovered \
  /mnt/pool1/secure-backups/full-snapshots/documents@manual-2022-07-02_22-18 \
  /mnt/pool1/secure-backups/incremental-snapshots/documents@auto-2022-07-05_00-00
```
