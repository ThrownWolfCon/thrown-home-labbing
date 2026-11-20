---
title: "Cap a container with cgroups"
linkTitle: "cgroup limits"
description: "Limit a container's memory, CPU, and process count, watch the kernel enforce each limit, and find the limits in the cgroup filesystem."
weight: 30
params:
  topic: tutorial
  area: "Containers"
  time: "about 20 minutes"
  difficulty: "Intermediate"
tags: ["Containers"]
---

{{< lab-meta >}}

## Goal

Limit a container's memory, CPU, and process count, watch the kernel enforce each limit, and find the limits in the cgroup filesystem.

## You'll need

- Docker ([Install Docker on Ubuntu]({{< ref "/docs/labs/containers/install-docker" >}}))
- cgroup v2, the default on modern distros. Check:

```bash
stat -fc %T /sys/fs/cgroup     # should print cgroup2fs
```

## Background

Namespaces control what a process can *see*. cgroups control how much it can *use*: CPU, memory, I/O, and number of processes. Docker's `--memory`, `--cpus`, and `--pids-limit` flags, and systemd's `MemoryMax=`, `CPUQuota=`, and `TasksMax=`, are friendly wrappers around the same kernel feature.

## Do it

1. **Memory.** Give a container 50 MB and try to use 100 MB:

    ```bash
    docker run --rm --memory 50m --memory-swap 50m python:3.12-alpine \
      python -c "x = bytearray(100*1024*1024); print('allocated')"
    echo "exit code: $?"
    ```

2. **CPU.** Limit a busy loop to half a core and watch it:

    ```bash
    docker run -d --name cpu-hog --cpus 0.5 alpine sh -c 'while :; do :; done'
    docker stats --no-stream cpu-hog
    ```

3. **Find the limit in the cgroup filesystem:**

    ```bash
    CID=$(docker inspect -f '{{.Id}}' cpu-hog)
    cat /sys/fs/cgroup/system.slice/docker-$CID.scope/cpu.max
    systemd-cgls --no-pager | grep -A2 docker-$CID
    ```

4. **Process count.** Cap it at 20 and launch 50:

    ```bash
    docker run --rm --pids-limit 20 alpine sh -c 'for i in $(seq 1 50); do sleep 30 & done; wait'
    ```

## What you should see

- Step 1: no `allocated` line. The container is OOM-killed and the exit code is `137` (128 + signal 9).
- Step 2: `CPU %` hovers around 50%.
- Step 3: `cpu.max` reads `50000 100000`: 50 ms of CPU every 100 ms.
- Step 4: errors like `can't fork: Resource temporarily unavailable` once the limit is hit.

{{< callout type="default" >}}
**Exit code 137 in production**

A container that keeps exiting with 137 is usually hitting its memory limit. Confirm with `docker inspect <container> --format '{{.State.OOMKilled}}'` and `journalctl -k | grep -i oom`.
{{< /callout >}}

## Cleanup

```bash
docker rm -f cpu-hog
```

## Next steps

- Do the same thing without Docker: `sudo systemd-run --scope -p MemoryMax=50M python3 -c "x = bytearray(100*1024*1024)"`.
- Watch live per-cgroup usage with `systemd-cgtop`.
- Find any process's cgroup with `cat /proc/<pid>/cgroup`.
