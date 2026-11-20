---
title: "Skills map"
description: "Use this to find labs that practice a certification topic."
weight: 30
params:
  topic: reference
---

Use this to find labs that practice a certification topic. The mapping is approximate: a lab covers part of a topic, not all of it.

## LPIC-1

| Topic | Labs |
| --- | --- |
| 101 System Architecture | [Boot targets and slow startups]({{< ref "/docs/labs/linux/boot-and-dependencies" >}}), [Disk full? Find out why]({{< ref "/docs/labs/storage/disk-full" >}}) |
| 102 Linux Installation and Package Management | [Install Docker on Ubuntu]({{< ref "/docs/labs/containers/install-docker" >}}), [Ship journald logs to Loki with Alloy]({{< ref "/docs/labs/observability/alloy-loki" >}}) |
| 103 GNU and Unix Commands | [Edit config files with sed]({{< ref "/docs/labs/linux/sed-config-edits" >}}), [The deleted-but-open file]({{< ref "/docs/labs/storage/deleted-but-open" >}}) |
| 104 Devices, Linux Filesystems, FHS | [Disk full? Find out why]({{< ref "/docs/labs/storage/disk-full" >}}), [The deleted-but-open file]({{< ref "/docs/labs/storage/deleted-but-open" >}}) |
| 105 Shells, Scripting and Data Management | [Edit config files with sed]({{< ref "/docs/labs/linux/sed-config-edits" >}}) |
| 107 Administrative Tasks | [Replace cron with a systemd timer]({{< ref "/docs/labs/linux/systemd-timer" >}}) |
| 108 Essential System Services | [Debug a failing service]({{< ref "/docs/labs/linux/debug-failing-service" >}}), [Write your own unit safely]({{< ref "/docs/labs/linux/write-your-own-unit" >}}), [Ship journald logs to Loki with Alloy]({{< ref "/docs/labs/observability/alloy-loki" >}}) |
| 109 Networking Fundamentals | [Layer-by-layer network troubleshooting]({{< ref "/docs/labs/networking/layered-troubleshooting" >}}), [Connection refused vs. timeout]({{< ref "/docs/labs/networking/refused-vs-timeout" >}}) |
| 110 Security | [Harden a service]({{< ref "/docs/labs/linux/harden-a-service" >}}), [Passwordless SSH]({{< ref "/docs/labs/security/passwordless-ssh" >}}), [Your own certificate authority]({{< ref "/docs/labs/security/own-ca" >}}) |

## Network+

| Objective | Labs |
| --- | --- |
| 5.1 Troubleshooting methodology | [Troubleshooting method]({{< ref "/docs/getting-started/troubleshooting-method" >}}), every lab |
| Network troubleshooting tools | [Layer-by-layer network troubleshooting]({{< ref "/docs/labs/networking/layered-troubleshooting" >}}) |
| Connectivity issues | [Connection refused vs. timeout]({{< ref "/docs/labs/networking/refused-vs-timeout" >}}) |

## Day-to-day support work

| Skill | Labs |
| --- | --- |
| Reading logs | [Debug a failing service]({{< ref "/docs/labs/linux/debug-failing-service" >}}), [Ship journald logs to Loki with Alloy]({{< ref "/docs/labs/observability/alloy-loki" >}}) |
| Containers | [Multi-container app with Compose]({{< ref "/docs/labs/containers/compose-app" >}}), [Cap a container with cgroups]({{< ref "/docs/labs/containers/cgroups-limits" >}}) |
| Git and version control | [Recover "lost" commits with reflog]({{< ref "/docs/labs/git/reflog-recovery" >}}), [Untangle a merge conflict]({{< ref "/docs/labs/git/merge-conflict" >}}) |
| TLS and certificates | [Your own certificate authority]({{< ref "/docs/labs/security/own-ca" >}}) |
