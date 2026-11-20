---
title: "Replace cron with a systemd timer"
linkTitle: "systemd timers"
description: "Schedule a job with a .timer unit instead of cron, and learn why timers are easier to debug."
weight: 50
params:
  topic: tutorial
  area: "Linux & systemd"
  time: "about 20 minutes"
  difficulty: "Beginner"
tags: ["Linux"]
---

{{< lab-meta >}}

## Goal

Schedule a job with a `.timer` unit instead of cron, and learn why timers are easier to debug.

## You'll need

- A systemd-based Linux machine with `sudo`

## Setup

A timer is two units: a `.service` that does the work, and a `.timer` with the same name that says when.

```bash
sudo tee /etc/systemd/system/heartbeat.service > /dev/null <<'EOF'
[Unit]
Description=Write a heartbeat to the journal

[Service]
Type=oneshot
ExecStart=/usr/bin/logger "heartbeat: still alive"
EOF

sudo tee /etc/systemd/system/heartbeat.timer > /dev/null <<'EOF'
[Unit]
Description=Run heartbeat every minute

[Timer]
OnCalendar=*-*-* *:*:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

sudo systemctl daemon-reload
```

## Do it

1. Start the timer (not the service):

    ```bash
    sudo systemctl enable --now heartbeat.timer
    ```

2. See it scheduled:

    ```bash
    systemctl list-timers heartbeat.timer
    ```

3. Watch it fire:

    ```bash
    journalctl -u heartbeat.service -f
    ```

4. Watch every timer on the box count down:

    ```bash
    watch -n 2 -d systemctl list-timers --all
    ```

5. Check a calendar expression before using it:

    ```bash
    systemd-analyze calendar "Mon..Fri 08:30"
    ```

## What you should see

`list-timers` shows the `NEXT` run, how long until it (`LEFT`), the `LAST` run, and which service it `ACTIVATES`. Every minute, a `heartbeat: still alive` line appears in the journal.

### Why bother instead of cron?

| | cron | systemd timer |
| --- | --- | --- |
| Logs | Mailed or lost unless you redirect | In the journal under the service name |
| Missed runs (machine was off) | Skipped | `Persistent=true` catches up |
| Run it now to test | Copy the command by hand | `systemctl start heartbeat.service` |
| Resource limits and sandboxing | No | Everything a service can do |

## Cleanup

```bash
sudo systemctl disable --now heartbeat.timer
sudo rm -f /etc/systemd/system/heartbeat.{service,timer}
sudo systemctl daemon-reload
```

## Next steps

- Use `OnBootSec=5min` and `OnUnitActiveSec=1h` for "five minutes after boot, then hourly."
- Add `RandomizedDelaySec=30` so many machines don't all fire at once.
- Convert a real crontab entry of yours into a timer.
