---
title: "The deleted-but-open file"
linkTitle: "Deleted-but-open files"
description: "Recognize when df says a disk is full but du can't find the space, and fix it without rebooting."
weight: 20
params:
  topic: tutorial
  area: "Storage"
  time: "about 15 minutes"
  difficulty: "Intermediate"
tags: ["Storage"]
---

{{< lab-meta >}}

## Goal

Recognize when `df` says a disk is full but `du` can't find the space, and fix it without rebooting.

## You'll need

- A Linux machine with `sudo` and `lsof`
- The throwaway filesystem from [Disk full? Find out why]({{< ref "/docs/labs/storage/disk-full" >}}). Re-run its **Setup** section if you cleaned it up.

## Background

Deleting a file removes its name, not its data. If a process still has the file open, the space isn't freed until that process closes it. This is the classic cause of "`df` says 100% but `du` adds up to much less," usually after someone deletes a huge log file a service is still writing to.

## Do it

1. Start a process that holds a file open and keeps writing to it:

    ```bash
    ( exec 3>/mnt/tiny/app.log; while true; do head -c 1M /dev/zero >&3; sleep 1; done ) &
    sleep 10
    ```

2. "Clean up" the log the wrong way:

    ```bash
    rm /mnt/tiny/app.log
    ```

3. Compare the two views:

    ```bash
    df -h /mnt/tiny
    du -sh /mnt/tiny
    ```

4. Find the culprit:

    ```bash
    sudo lsof +L1 /mnt/tiny
    ```

5. Free the space. On a real server you'd restart or reload the service. Here, stop the writer:

    ```bash
    kill %1
    df -h /mnt/tiny
    ```

## What you should see

- Step 3: `df` keeps climbing while `du` shows almost nothing.
- Step 4: `lsof +L1` lists the process, its PID, file descriptor `3w`, a size, `NLINK` of `0`, and the path marked `(deleted)`.
- Step 5: the space comes back the moment the process exits.

{{< callout type="default" >}}
**Can't restart the service?**

You can truncate the deleted file through `/proc` to free the space right away:

```bash
sudo truncate -s 0 /proc/<PID>/fd/<FD>
```

Next time, empty a log in place with `truncate -s 0 file.log` (or `: > file.log`) instead of `rm`, or let `logrotate` handle it.
{{< /callout >}}

## Cleanup

```bash
kill %1 2>/dev/null
sudo umount /mnt/tiny
sudo rmdir /mnt/tiny
rm ~/tiny.img
```

## Next steps

- Run `sudo lsof +L1` on your real system. Browsers and journald often hold a few deleted files.
- Read about `copytruncate` vs. `create` in `man logrotate`.
