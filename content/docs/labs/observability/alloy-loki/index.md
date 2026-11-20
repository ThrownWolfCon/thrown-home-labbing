---
title: "Ship journald logs to Loki with Alloy"
linkTitle: "Alloy and Loki"
description: "Run Loki and Grafana locally, collect your machine's journald logs with Grafana Alloy, and query them with LogQL."
weight: 10
params:
  topic: tutorial
  area: "Observability"
  time: "about 45 minutes"
  difficulty: "Intermediate"
tags: ["Observability"]
---

{{< lab-meta >}}

## Goal

Run Loki and Grafana locally, collect your machine's journald logs with Grafana Alloy, and query them with LogQL. Then break the pipeline and diagnose it.

## You'll need

- Ubuntu with `sudo`
- Docker with the Compose plugin ([Install Docker on Ubuntu]({{< ref "/docs/labs/containers/install-docker" >}}))

## How the pieces fit

```text
journald ──▶ Alloy (loki.source.journal ──▶ loki.write) ──▶ Loki :3100 ──▶ Grafana :3000
```

- **Alloy** collects telemetry. Its config is a pipeline of *components*: one reads the journal, one sends to Loki.
- **Loki** stores logs and indexes only their labels.
- **Grafana** is where you query and graph them.

## Setup

### 1. Run Loki and Grafana

```bash
mkdir -p ~/loki-lab && cd ~/loki-lab
cat > compose.yaml <<'EOF'
services:
  loki:
    image: grafana/loki:latest
    ports:
      - "127.0.0.1:3100:3100"
    command: -config.file=/etc/loki/local-config.yaml

  grafana:
    image: grafana/grafana:latest
    ports:
      - "127.0.0.1:3000:3000"
    environment:
      GF_AUTH_ANONYMOUS_ENABLED: "true"
      GF_AUTH_ANONYMOUS_ORG_ROLE: Admin
EOF

docker compose up -d
curl -s localhost:3100/ready     # repeat until it prints "ready"
```

{{< callout type="warning" >}}
**Lab-only settings**

Anonymous administrator access and the default Loki config are fine on `127.0.0.1` for a lab. Never expose this setup to a network.
{{< /callout >}}

### 2. Install Alloy

```bash
sudo mkdir -p /etc/apt/keyrings
sudo wget -qO /etc/apt/keyrings/grafana.asc https://apt.grafana.com/gpg-full.key
sudo chmod 644 /etc/apt/keyrings/grafana.asc
echo "deb [signed-by=/etc/apt/keyrings/grafana.asc] https://apt.grafana.com stable main" \
  | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt-get update && sudo apt-get install -y alloy
```

## Do it

### 1. Configure Alloy

Back up the default config, then replace it:

```bash
sudo cp /etc/alloy/config.alloy /etc/alloy/config.alloy.orig
sudo tee /etc/alloy/config.alloy > /dev/null <<'EOF'
loki.relabel "journal" {
  forward_to = []

  rule {
    source_labels = ["__journal__systemd_unit"]
    target_label  = "unit"
  }
  rule {
    source_labels = ["__journal_priority_keyword"]
    target_label  = "level"
  }
}

loki.source.journal "read" {
  forward_to    = [loki.write.local.receiver]
  relabel_rules = loki.relabel.journal.rules
  labels        = { job = "journal", host = constants.hostname }
  max_age       = "12h"
}

loki.write "local" {
  endpoint {
    url = "http://127.0.0.1:3100/loki/api/v1/push"
  }
}
EOF
```

Alloy runs as the `alloy` user, which needs permission to read the journal:

```bash
sudo usermod -aG systemd-journal alloy
sudo systemctl enable --now alloy
sudo systemctl restart alloy
systemctl status alloy --no-pager
```

### 2. Query your logs

Open <http://localhost:3000>, go to **Connections > Data sources > Add data source > Loki**, set the URL to `http://loki:3100`, and click **Save & test**. Then open **Explore** and try these LogQL queries:

```text
{job="journal"}
{job="journal", unit="ssh.service"}
{job="journal"} |= "error"
sum by (unit) (count_over_time({job="journal"}[5m]))
```

Generate something to find:

```bash
logger -p user.err "alloy-lab: something broke on purpose"
```

Then query `{job="journal"} |= "alloy-lab"`.

### 3. Break it and diagnose it

Stop Loki and watch Alloy complain:

```bash
docker compose stop loki
journalctl -u alloy -f
```

Start it again with `docker compose start loki` and watch Alloy recover.

Alloy also has a built-in debug UI at <http://127.0.0.1:12345>. It shows each component, its health, and how data flows between them.

## What you should see

- `systemctl status alloy` shows `active (running)`.
- In Explore, journal lines appear with `unit`, `level`, and `host` labels, and your `alloy-lab` test line shows up within a few seconds.
- With Loki stopped, the Alloy journal shows retries and eventually a line like:

```text
level=error msg="final error sending batch, no retries left, dropping data" component_id=loki.write.local
```

That message means Alloy gave up on a batch after its retries ran out. Those log lines are lost, which is why you alert on it.

**Troubleshooting:**

| Symptom | Check |
| --- | --- |
| Alloy won't start | `journalctl -u alloy -n 50` for a config syntax error and the line number |
| Running but no logs in Loki | Is `alloy` in `systemd-journal`? (`id alloy`). Restart Alloy after adding it. |
| Where do the config and environment variables come from? | `systemctl cat alloy` shows `EnvironmentFile=` and drop-ins |

{{< callout type="error" >}}
**Keep credentials out of your notes**

If you later send to Grafana Cloud, the API token usually lives in an environment file referenced by `systemctl cat alloy`. Don't paste that output, or a screenshot of it, into a wiki, ticket, or Git repository.
{{< /callout >}}

## Cleanup

```bash
sudo systemctl disable --now alloy
sudo cp /etc/alloy/config.alloy.orig /etc/alloy/config.alloy
sudo gpasswd -d alloy systemd-journal
cd ~/loki-lab && docker compose down -v && cd ~ && rm -rf ~/loki-lab
```

To remove Alloy completely:

```bash
sudo apt-get remove -y alloy
sudo rm /etc/apt/sources.list.d/grafana.list
```

## Next steps

- Add `prometheus.exporter.unix` to collect machine metrics and send them to Prometheus or Mimir.
- Use `loki.process` to parse a structured log line into labels.
- Build a dashboard panel of error counts by unit.
