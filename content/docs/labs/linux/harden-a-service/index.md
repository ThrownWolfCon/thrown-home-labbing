---
title: "Harden a service"
linkTitle: "Harden a service"
description: "Use systemd-analyze security to score a service's exposure, then add sandboxing and resource limits and watch the score drop."
weight: 40
params:
  topic: tutorial
  area: "Linux & systemd"
  time: "about 30 minutes"
  difficulty: "Intermediate"
tags: ["Linux"]
---

{{< lab-meta >}}

## Goal

Use `systemd-analyze security` to score a service's exposure, then add sandboxing and resource limits and watch the score drop.

## You'll need

- A systemd-based Linux machine with `sudo` (systemd 240 or later)

## Background

- **Resource control** uses cgroups. Every service runs in its own cgroup, and directives like `MemoryMax=`, `CPUQuota=`, and `TasksMax=` set limits on it.
- **Hardening** uses namespaces, capabilities, and seccomp. Directives like `ProtectSystem=` and `PrivateTmp=` limit what the process can see and do, so a compromised service can't do much damage.

## Setup

Look at the current state of your system first:

```bash
systemd-analyze security | head -20
```

Each service gets an exposure score from 0 (locked down) to 10 (wide open). Most services shipped by distros sit at 9-something.

Create a small long-running service to harden:

```bash
sudo tee /etc/systemd/system/sandbox-demo.service > /dev/null <<'EOF'
[Unit]
Description=Hardening demo

[Service]
ExecStart=/bin/sh -c 'while true; do echo "tick"; sleep 30; done'
EOF

sudo systemctl daemon-reload
sudo systemctl start sandbox-demo.service
```

## Do it

1. Score it:

    ```bash
    systemd-analyze security sandbox-demo.service | tail -1
    ```

2. Add hardening with a drop-in:

    ```bash
    sudo systemctl edit sandbox-demo.service
    ```

    Paste this between the comment lines:

    ```ini
    [Service]
    DynamicUser=yes
    ProtectSystem=strict
    ProtectHome=yes
    PrivateTmp=yes
    PrivateDevices=yes
    NoNewPrivileges=yes
    ProtectKernelTunables=yes
    ProtectKernelModules=yes
    ProtectControlGroups=yes
    RestrictAddressFamilies=AF_UNIX
    CapabilityBoundingSet=
    SystemCallFilter=@system-service
    MemoryMax=50M
    TasksMax=10
    ```

3. Restart and score it again:

    ```bash
    sudo systemctl restart sandbox-demo.service
    systemctl status sandbox-demo.service
    systemd-analyze security sandbox-demo.service | tail -1
    ```

4. See the limits applied:

    ```bash
    systemctl show sandbox-demo.service -p MemoryMax -p TasksMax -p MemoryCurrent
    ```

## What you should see

Before hardening, the last line reads something like:

```text
→ Overall exposure level for sandbox-demo.service: 9.6 UNSAFE 😨
```

After, it should drop to somewhere from 2 to 4 (`OK` or `MEDIUM`). The full report shows a ✓ or ✗ beside each check, so you can see which directives moved the score.

{{< callout type="warning" >}}
**Harden a real service carefully**

Every directive takes something away. If a real service breaks after hardening, check `journalctl -u <unit>` for `Permission denied` or `Operation not permitted`, and remove directives one at a time to find the culprit.
{{< /callout >}}

## Cleanup

```bash
sudo systemctl stop sandbox-demo.service
sudo rm -f /etc/systemd/system/sandbox-demo.service
sudo rm -rf /etc/systemd/system/sandbox-demo.service.d
sudo systemctl daemon-reload
```

## Next steps

- Pick a real low-risk service on a test VM and get its score under 5 without breaking it.
- Watch your demo in the cgroup tree with `systemd-cgls` and `systemd-cgtop`.
- Set `MemoryMax=1M` and see what happens when the limit is too low.
