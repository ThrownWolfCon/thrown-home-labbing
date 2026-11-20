---
title: "Connection refused vs. timeout"
linkTitle: "Refused vs. timeout"
description: "Tell from a single failed connection whether nothing is listening, a firewall is dropping packets, or a firewall is rejecting them, and confirm it with a packet capture."
weight: 20
params:
  topic: tutorial
  area: "Networking"
  time: "about 20 minutes"
  difficulty: "Intermediate"
tags: ["Networking"]
---

{{< lab-meta >}}

## Goal

Tell from a single failed connection whether nothing is listening, a firewall is dropping packets, or a firewall is rejecting them, and confirm it with a packet capture.

## You'll need

- A Linux machine with `sudo`
- `sudo apt install netcat-openbsd tcpdump`

## Background

| Symptom | What happened on the wire | Usual cause |
| --- | --- | --- |
| **Connection refused** (fast) | SYN → RST | Host is up, nothing listening on that port |
| **Timeout** (slow) | SYN → nothing | Firewall dropping, or a routing problem |
| **Refused, but a service is running** | SYN → RST or ICMP from a firewall | Firewall set to *reject*, or the service is bound to a different address |

## Setup

Open a second terminal and start a capture on the loopback interface:

```bash
sudo tcpdump -i lo -nn port 8080
```

## Do it

1. **Nothing listening.** In your first terminal:

    ```bash
    nc -zv 127.0.0.1 8080
    ```

2. **Something listening.** Start a listener, then test again:

    ```bash
    nc -l 127.0.0.1 8080 &
    nc -zv 127.0.0.1 8080
    ss -tlpn | grep 8080
    ```

3. **Firewall drops it.** Stop the listener (`kill %1`), start a fresh one, then drop the traffic:

    ```bash
    nc -lk 127.0.0.1 8080 &
    sudo iptables -I INPUT -i lo -p tcp --dport 8080 -j DROP
    nc -zv -w 5 127.0.0.1 8080
    ```

4. **Firewall rejects it.** Swap the rule:

    ```bash
    sudo iptables -D INPUT -i lo -p tcp --dport 8080 -j DROP
    sudo iptables -I INPUT -i lo -p tcp --dport 8080 -j REJECT --reject-with tcp-reset
    nc -zv -w 5 127.0.0.1 8080
    ```

5. **Bound to the wrong address.** Remove the firewall rule and listen only on loopback, then connect to your LAN IP:

    ```bash
    sudo iptables -D INPUT -i lo -p tcp --dport 8080 -j REJECT --reject-with tcp-reset
    ss -tlpn | grep 8080           # note 127.0.0.1:8080
    nc -zv $(hostname -I | awk '{print $1}') 8080
    ```

## What you should see

| Step | `nc` says | tcpdump shows |
| --- | --- | --- |
| 1 | `Connection refused`, instantly | `Flags [S]` then `Flags [R.]` |
| 2 | `succeeded!` | Full handshake: `[S]`, `[S.]`, `[.]` |
| 3 | `timed out` after 5 seconds | Repeated `[S]` and nothing back |
| 4 | `Connection refused`, instantly, even though a listener is running | `[S]` then `[R.]` |
| 5 | `Connection refused` | Nothing on `lo`: the packet went to your LAN interface, where nothing listens |

Steps 1 and 4 look identical to the client. Only `ss` on the server tells you whether something is really listening. That's why you check both ends.

## Cleanup

```bash
kill %1 2>/dev/null
sudo iptables -D INPUT -i lo -p tcp --dport 8080 -j DROP 2>/dev/null
sudo iptables -D INPUT -i lo -p tcp --dport 8080 -j REJECT --reject-with tcp-reset 2>/dev/null
sudo iptables -L INPUT -n --line-numbers | grep 8080   # should print nothing
```

Stop tcpdump with **Ctrl+C**.

## Next steps

- Repeat step 3 between two VMs with `ufw` instead of `iptables`.
- Add `curl -v telnet://127.0.0.1:8080`. It tests TCP only, with no TLS handshake, and waits until you press **Ctrl+C**.
