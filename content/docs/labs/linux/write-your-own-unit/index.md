---
title: "Write your own unit safely"
linkTitle: "Write a unit"
description: "Write a service unit from scratch, control its ordering, and see exactly what enable and WantedBy= do on disk."
weight: 20
params:
  topic: tutorial
  area: "Linux & systemd"
  time: "about 20 minutes"
  difficulty: "Beginner"
tags: ["Linux"]
---

{{< lab-meta >}}

## Goal

Write a service unit from scratch, control its ordering, and see exactly what `enable` and `WantedBy=` do on disk.

## You'll need

- A systemd-based Linux machine with `sudo`

## How a unit file is organized

| Section | Question it answers | Examples |
| --- | --- | --- |
| `[Unit]` | When, and in what order? | `Description=`, `After=`, `Wants=`, `Requires=` |
| `[Service]` | How does it run? | `ExecStart=`, `User=`, `Restart=`, `Type=` |
| `[Install]` | Where does `enable` hook it in? | `WantedBy=multi-user.target` |

## Setup

Create a harmless service that only writes one line to the journal. It runs only when you start it and doesn't touch existing units.

```bash
sudo tee /etc/systemd/system/demo.service > /dev/null <<'EOF'
[Unit]
Description=Demo ordering unit
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/logger "demo.service ran after network-online"
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
```

## Do it

1. Run it and check the result:

    ```bash
    sudo systemctl start demo.service
    journalctl -u demo.service --no-pager
    systemctl list-dependencies demo.service
    systemd-analyze verify demo.service
    ```

2. Change the ordering. Edit the file, change `After=` to `Before=`, then:

    ```bash
    sudo systemctl daemon-reload
    systemctl show demo.service -p After -p Before
    ```

3. Enable it and find the symlink:

    ```bash
    sudo systemctl enable demo.service
    ls -l /etc/systemd/system/multi-user.target.wants/ | grep demo
    ```

## What you should see

- The journal shows your `logger` line, and `systemd-analyze verify` prints nothing (no news is good news).
- `systemctl show` reflects whichever of `After=` or `Before=` you set.
- `enable` creates a symlink in `/etc/systemd/system/multi-user.target.wants/`. That's all `WantedBy=` means: "when this target is reached, start this unit too."

{{< callout type="info" >}}
**Wants vs. Requires, After vs. Before**

`Wants=` and `Requires=` are about *whether* another unit gets started. `After=` and `Before=` are about *order*. They're independent: `Wants=network-online.target` without `After=` starts both at the same time.
{{< /callout >}}

## Cleanup

```bash
sudo systemctl disable --now demo.service
sudo rm /etc/systemd/system/demo.service
sudo systemctl daemon-reload
```

## What to avoid while practicing

- **`systemctl isolate <target>`** on a desktop or remote machine. It stops everything not in that target and can end your session.
- **`systemctl set-default`** to something odd. It changes what the next boot does. If you practice it, set it back right away.
- **Masking, disabling, or editing existing system units.** Stick to your own demo unit.

## Next steps

- Add `User=nobody` and `Restart=on-failure` and turn it into a long-running `Type=simple` service.
- Override a setting with a drop-in instead of editing the file: `sudo systemctl edit demo.service`, then check `systemctl cat demo.service`.
