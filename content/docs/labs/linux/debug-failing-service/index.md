---
title: "Debug a failing service"
linkTitle: "Debug a service"
description: "Read a failing service's state, exit code, and logs, and tell the difference between \"systemd couldn't start it\" and \"the program started and then failed.\""
weight: 10
params:
  topic: tutorial
  area: "Linux & systemd"
  time: "about 20 minutes"
  difficulty: "Beginner"
tags: ["Linux"]
---

{{< lab-meta >}}

## Goal

Read a failing service's state, exit code, and logs, and tell the difference between "systemd couldn't start it" and "the program started and then failed."

## You'll need

- A systemd-based Linux machine with `sudo`

New to systemd? {{< modal text="What's systemd?" title="systemd in 30 seconds" >}}
**systemd** is the program that starts first when Linux boots, and then starts and supervises everything else.

- A **unit** is anything systemd manages. A **service** unit, such as `ssh.service`, runs a program.
- `systemctl` is the command you use to start, stop, and check units.
- `journalctl` reads the logs that systemd collects from every service.

Most modern distributions use it, including Ubuntu, Fedora, Debian, and RHEL.
{{< /modal >}}

## Setup

Create a service that points at a binary that doesn't exist:

```bash
sudo tee /etc/systemd/system/broken.service > /dev/null <<'EOF'
[Unit]
Description=Deliberately broken demo

[Service]
ExecStart=/usr/local/bin/does-not-exist
EOF

sudo systemctl daemon-reload
```

## Do it

### 1. Start it and investigate

```bash
sudo systemctl start broken.service
```

It fails. Before reading on, investigate like you would on the job:

```bash
systemctl status broken.service
journalctl -u broken.service --no-pager
systemctl show broken.service -p Result -p ExecMainStatus -p ExecMainCode
```

### 2. Make the program itself fail

Now the binary exists, but the app exits with an error. Edit the unit:

```bash
sudo systemctl edit --full broken.service
```

Change `ExecStart=` to:

```ini
ExecStart=/bin/sh -c 'echo "starting up"; echo "config missing" >&2; exit 1'
```

Then:

```bash
sudo systemctl daemon-reload
sudo systemctl start broken.service
journalctl -u broken.service --no-pager
```

### 3. Make it crash-loop

Edit the unit again so the `[Service]` section reads:

```ini
[Service]
ExecStart=/bin/sh -c 'echo "crashing"; exit 1'
Restart=on-failure
RestartSec=2
```

Then watch it:

```bash
sudo systemctl daemon-reload
sudo systemctl start broken.service
journalctl -u broken.service -f
```

Press **Ctrl+C** to stop following once it gives up.

## What you should see

**Step 1:** `status=203/EXEC`. systemd never ran your program because it couldn't execute the binary.

**Step 2:** Both lines, `starting up` and `config missing`, show up in the journal, because journald captures stdout and stderr. The exit status is now `1`: the failure is in the app, not in systemd.

**Step 3:** The service restarts every two seconds until systemd hits its start limit and logs `Start request repeated too quickly`. It stays failed until you clear it:

```bash
sudo systemctl reset-failed broken.service
```

### Common exit codes

| Status | Meaning |
| --- | --- |
| `203/EXEC` | Binary missing or not executable |
| `200/CHDIR` | Bad `WorkingDirectory=` |
| `217/USER` | Bad `User=` |
| `1` (or another small number) | The program ran and exited with an error |
| `status=SEGV` / `ABRT` | The program crashed |

{{< callout type="default" >}}
**The interview-ready workflow**

When someone says "the service won't start":

1. `systemctl status <unit>` for the state and exit code
2. `journalctl -u <unit> -b` for the full story this boot
3. `journalctl -p err -b` in case the cause is outside the unit (disk, network, kernel)
4. `systemctl cat <unit>` to confirm what's actually configured, including drop-ins
{{< /callout >}}

## Cleanup

```bash
sudo systemctl stop broken.service
sudo rm -f /etc/systemd/system/broken.service
sudo rm -rf /etc/systemd/system/broken.service.d
sudo systemctl daemon-reload
sudo systemctl reset-failed
```

## Next steps

- Set `User=nobody` and `WorkingDirectory=/nope` to produce `217/USER` and `200/CHDIR` yourself.
- Add `StartLimitBurst=3` and `StartLimitIntervalSec=30` under `[Unit]` and see how the crash loop changes.
- Run `systemctl --failed` on a machine you didn't set up. It's a great first command on an unfamiliar box.
