---
title: "Disk full? Find out why"
linkTitle: "Disk full"
description: "Find what's using disk space, including the \"full disk with space free\" case caused by running out of inodes, without filling your real filesystem."
weight: 10
params:
  topic: tutorial
  area: "Storage"
  time: "about 20 minutes"
  difficulty: "Beginner"
tags: ["Storage"]
---

{{< lab-meta >}}

## Goal

Find what's using disk space, including the "full disk with space free" case caused by running out of inodes, without filling your real filesystem.

## You'll need

- A Linux machine with `sudo`
- Optional: `sudo apt install ncdu`

## Background: the four storage questions

| Question | Start with |
| --- | --- |
| **Capacity:** what's using space? | `df -h`, `df -i`, `du`, `ncdu` |
| **Structure:** what's attached and how is it laid out? | `lsblk -f`, `findmnt`, `blkid` |
| **Health:** is the disk failing? | `smartctl -a`, `nvme smart-log`, `journalctl -k -p err` |
| **Performance:** is it slow, and why? | `iostat -xz 1`, `iotop -o`, `pidstat -d 1` |

This lab covers capacity and structure.

## Setup

Make a small, throwaway filesystem in a file so you can fill it safely:

```bash
truncate -s 64M ~/tiny.img
mkfs.ext4 -q -N 2000 ~/tiny.img       # only about 2000 inodes
sudo mkdir -p /mnt/tiny
sudo mount -o loop ~/tiny.img /mnt/tiny
sudo chown "$USER" /mnt/tiny
```

## Do it

1. **Get your bearings:**

    ```bash
    lsblk -f
    findmnt /mnt/tiny
    df -h /mnt/tiny
    df -i /mnt/tiny
    ```

2. **Fill it with one big file:**

    ```bash
    fallocate -l 50M /mnt/tiny/big.bin
    df -h /mnt/tiny
    ```

    Now find it as if you didn't know where it was:

    ```bash
    du -xh --max-depth=1 /mnt/tiny | sort -h
    find /mnt/tiny -xdev -type f -size +10M -exec du -h {} + | sort -rh
    ```

3. **Run out of inodes instead.** Delete the big file and create lots of tiny ones:

    ```bash
    rm /mnt/tiny/big.bin
    mkdir /mnt/tiny/cache
    for i in $(seq 1 3000); do touch /mnt/tiny/cache/session_$i; done
    ```

    Watch the errors, then check both views:

    ```bash
    df -h /mnt/tiny
    df -i /mnt/tiny
    ```

## What you should see

- Step 2: `df -h` shows the filesystem nearly full, and `find` points straight at `big.bin`.
- Step 3: `touch` fails with `No space left on device` while `df -h` still shows plenty of free space. `df -i` shows `IUse%` at 100%.

{{< callout type="default" >}}
**Where to look on a real server**

- Millions of tiny files: session stores, mail queues, cache directories
- `journalctl --disk-usage` and `/var/log`
- `docker system df`
- Package caches: `sudo apt clean` or `sudo dnf clean all`
- If `df` and `du` disagree, refer to [The deleted-but-open file]({{< ref "/docs/labs/storage/deleted-but-open" >}})
{{< /callout >}}

## Cleanup

```bash
sudo umount /mnt/tiny
sudo rmdir /mnt/tiny
rm ~/tiny.img
```

## Next steps

- Run `ncdu /mnt/tiny` (or `ncdu ~`) for an interactive view.
- Mount something *over* a directory that has files in it, and notice that `du` can no longer see those files but they still use space.
- Check your real disks' health: `sudo smartctl -a /dev/sda` or `sudo nvme smart-log /dev/nvme0`.
