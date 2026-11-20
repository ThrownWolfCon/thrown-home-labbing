---
title: "Boot targets and slow startups"
linkTitle: "Boot and slow startups"
description: "Understand targets (the modern runlevels), read a unit's dependencies, and find what's slowing your boot."
weight: 30
params:
  topic: tutorial
  area: "Linux & systemd"
  time: "about 15 minutes"
  difficulty: "Beginner"
tags: ["Linux"]
---

{{< lab-meta >}}

## Goal

Understand targets (the modern runlevels), read a unit's dependencies, and find what's slowing your boot. Everything here is read-only.

## You'll need

- A systemd-based Linux machine. No `sudo` needed.

## Do it

### 1. See where you are

```bash
systemctl get-default
systemctl list-units --type=target
```

Servers usually print `multi-user.target`; desktops print `graphical.target`. A target is the "state" the machine boots toward. Targets are named sync points that group units: look for `sysinit.target`, `basic.target`, `network.target`, and `multi-user.target` in the list.

### 2. Walk the dependency tree

```bash
systemctl list-dependencies multi-user.target
systemctl show ssh.service -p Wants -p Requires -p After -p Before
systemctl cat ssh.service
```

{{< callout type="default" >}}
No SSH server installed? Use `cron.service` or `systemd-journald.service` instead.
{{< /callout >}}

### 3. Find slow startups

```bash
systemd-analyze                        # firmware / loader / kernel / userspace split
systemd-analyze blame | head -15       # units sorted by how long they took
systemd-analyze critical-chain         # the chain that actually gated boot
systemd-analyze critical-chain ssh.service
```

## What you should see

`systemctl show ssh.service` lists far more `After=` entries than the unit file declares, because systemd adds implicit dependencies (`sysinit.target`, `basic.target`, the slice, and so on):

```text
Requires=sysinit.target -.mount ssh.socket system.slice
Wants=sshd-keygen.service
Before=shutdown.target
After=network.target ssh.socket nss-user-lookup.target system.slice sysinit.target basic.target ...
```

`critical-chain` reads bottom to top. The time after `@` is when the unit became active; the time after `+` is how long it took to start:

```text
└─network.target @3.845s
  └─NetworkManager.service @3.219s +626ms
    └─dbus.service @3.138s +79ms
      └─basic.target @3.070s
        └─sockets.target @3.070s
          └─snapd.socket @3.053s +16ms
            └─sysinit.target @3.049s
              └─snapd.apparmor.service @2.026s +1.022s
```

Here `snapd.apparmor.service` cost a full second before `sysinit.target` could be reached.

{{< callout type="warning" >}}
**blame vs. critical-chain**

`blame` shows how long each unit took, but units start in parallel, so the slowest unit isn't always the one delaying boot. `critical-chain` shows what actually held things up.
{{< /callout >}}

## Cleanup

Nothing to clean up. This lab is read-only.

## Next steps

- `systemd-analyze plot > boot.svg` and open it in a browser for a visual timeline.
- Compare `systemd-analyze blame` between a desktop and a minimal server VM.
