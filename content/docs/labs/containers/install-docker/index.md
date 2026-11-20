---
title: "Install Docker on Ubuntu"
linkTitle: "Install Docker"
description: "Install Docker Engine and the Compose plugin from Docker's own repository, and know how to remove it cleanly."
weight: 10
params:
  topic: tutorial
  area: "Containers"
  time: "about 15 minutes"
  difficulty: "Beginner"
tags: ["Containers"]
---

{{< lab-meta >}}

## Goal

Install Docker Engine and the Compose plugin from Docker's own repository, and know how to remove it cleanly.

## You'll need

- Ubuntu 22.04 or later with `sudo`
- The official reference: [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

## Setup

Remove any old or distro-packaged versions first. It's fine if apt says none are installed.

```bash
sudo apt-get remove docker.io docker-doc docker-compose podman-docker containerd runc
```

## Do it

1. Add Docker's signing key:

    ```bash
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    ```

2. Add the repository:

    ```bash
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
      https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
      | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    ```

3. Install:

    ```bash
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```

4. Verify:

    ```bash
    sudo systemctl status docker --no-pager
    sudo docker run --rm hello-world
    docker compose version
    ```

5. Optional: run Docker without `sudo`:

    ```bash
    sudo usermod -aG docker "$USER"
    newgrp docker
    docker ps
    ```

{{< callout type="warning" >}}
**The docker group is root-equivalent**

Anyone in the `docker` group can mount the host filesystem into a container as root. Only add accounts you'd trust with `sudo`.
{{< /callout >}}

## What you should see

`hello-world` prints `Hello from Docker!` and a short explanation of what just happened: the client contacted the daemon, the daemon pulled the image, and it created and ran a container.

**Troubleshooting:**

| Error | Fix |
| --- | --- |
| GPG or `NO_PUBKEY` error on `apt-get update` | `sudo chmod a+r /etc/apt/keyrings/docker.asc` |
| `permission denied ... docker.sock` | Use `sudo`, or log out and back in after step 5 |
| Need a specific version | `apt-cache madison docker-ce`, then `sudo apt-get install docker-ce=<VERSION>` |

{{< callout type="info" >}}
**docker-compose vs. docker compose**

The old standalone `docker-compose` binary is retired. The plugin installed above gives you `docker compose` (with a space), which is what the other labs use.
{{< /callout >}}

## Cleanup

Only if you want Docker gone. This deletes all images, containers, and volumes:

```bash
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo rm -rf /var/lib/docker /var/lib/containerd
sudo rm /etc/apt/sources.list.d/docker.list /etc/apt/keyrings/docker.asc
```

## Next steps

- Read the daemon's own logs: `journalctl -u docker -b`.
- Run several containers from one image: `docker run -d --name web1 -p 8124:80 nginx` and `docker run -d --name web2 -p 8125:80 nginx`.
