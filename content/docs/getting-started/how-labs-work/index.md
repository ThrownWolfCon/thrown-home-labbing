---
title: "How the labs work"
description: "## What you need"
weight: 10
params:
  topic: concept
---

## What you need

- A Linux machine you can use `sudo` on. The labs are written for **Ubuntu 24.04 or later**. Most commands work on Fedora and other systemd-based distros, and the labs call out differences where they matter.
- A terminal and a text editor.
- For container labs, Docker (refer to [Install Docker on Ubuntu]({{< ref "/docs/labs/containers/install-docker" >}})).

A VM is ideal. Multipass, VirtualBox, GNOME Boxes, or a Proxmox guest all work.

## The shape of every lab

| Section | What it's for |
| --- | --- |
| **Goal** | The skill the lab keeps sharp, in one or two sentences. |
| **You'll need** | Packages, permissions, or earlier labs. |
| **Setup** | Commands that build the scenario. Nothing touches existing system config. |
| **Do it** | The exercise itself, usually "break it, then investigate." |
| **What you should see** | Sample output and how to read it. |
| **Cleanup** | Commands that put the machine back the way it was. |
| **Going further** | Harder variations if you want more. |

## Conventions

- `<angle brackets>` are placeholders. Replace them, brackets included.
- Sample output uses the prompt `you@homelab:~$` and hosts like `example.com`. Details in your output, such as timestamps and IDs, differ.
- Lines starting with `#` inside code blocks are comments, not commands.

{{< callout type="default" >}}
**Work like it's a ticket**

Before you look at the answer, write down what you think is wrong and which command would prove it. That habit is the actual skill. Refer to [Troubleshooting method]({{< ref "/docs/getting-started/troubleshooting-method" >}}).
{{< /callout >}}
