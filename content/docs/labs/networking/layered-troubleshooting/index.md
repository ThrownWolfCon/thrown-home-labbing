---
title: "Layer-by-layer network troubleshooting"
linkTitle: "Layer-by-layer troubleshooting"
description: "Work a \"the network is broken\" complaint from the bottom of the stack to the top, knowing which command answers which question and what a bad result looks like."
weight: 10
params:
  topic: tutorial
  area: "Networking"
  time: "about 30 minutes"
  difficulty: "Intermediate"
tags: ["Networking"]
---

{{< lab-meta >}}

## Goal

Work a "the network is broken" complaint from the bottom of the stack to the top, knowing which command answers which question and what a bad result looks like.

## You'll need

- A Linux machine with network access
- Tools: `iproute2` (installed by default), plus:

```bash
sudo apt install dnsutils mtr-tiny netcat-openbsd tcpdump ethtool
```

{{< callout type="default" >}}
**Find your interface name**

Examples use `eth0`. Yours might be `enp3s0`, `wlp0s20f3`, or similar. Run `ip -br link` and substitute.
{{< /callout >}}

## Do it

Run each layer's commands against your own machine first, so you know what *healthy* looks like. Then try the breakages in [Next steps](#next-steps).

### 1. Link: is the interface up?

```bash
ip -br link              # brief view of interfaces and state
ip -s link show eth0     # RX/TX errors, drops, overruns
ethtool eth0             # speed, duplex, link detected
iw dev wlan0 link        # Wi-Fi signal and bitrate
```

**Bad looks like:** state `DOWN`, half duplex, error or drop counters that keep rising, weak Wi-Fi signal.

### 2. IP configuration and neighbors

```bash
ip -br addr              # addresses per interface
ip neigh                 # ARP/NDP table
resolvectl status        # DNS servers per interface
```

**Bad looks like:** no address, a `169.254.x.x` address (DHCP failed), duplicate IPs, `FAILED` neighbor entries.

### 3. Routing and reachability

```bash
ip route                 # is there a default route?
ip route get 1.1.1.1     # which route and interface would be used
ping -c 4 <gateway>      # can you reach the gateway?
ping -c 4 1.1.1.1        # can you reach the internet by IP?
mtr -rwc 50 example.com  # per-hop loss and latency
```

**Read it like this:** gateway fails → local problem. IP works but names fail → DNS (layer 4 below). Loss that starts at one hop *and continues to the end* → that hop or the link after it.

{{< callout type="info" >}}
**Loss in the middle of an mtr report**

Loss at a middle hop that drops back to 0% further along is usually a router that rate-limits replies to probes. It isn't real loss. Only loss that carries through to the final hop matters.
{{< /callout >}}

### 4. DNS

```bash
dig example.com                    # full query details
dig +short example.com @1.1.1.1    # bypass your local resolver
dig +trace example.com             # walk down from the root servers
getent hosts example.com           # what applications actually see
cat /etc/resolv.conf
```

**Read it like this:** if `dig @1.1.1.1` works but plain `dig` doesn't, your configured DNS server is the culprit.

### 5. Transport: ports and connections

```bash
ss -tulpn                # what's listening, and which process owns it
ss -tan state established
nc -zv example.com 443   # is this TCP port reachable?
```

Refer to [Connection refused vs. timeout]({{< ref "/docs/labs/networking/refused-vs-timeout" >}}) for how to read failures here.

### 6. Firewall

```bash
sudo nft list ruleset
sudo iptables -L -n -v
sudo ufw status verbose
sudo firewall-cmd --list-all     # RHEL/Fedora
```

Check the packet counters on rules to see which ones are actually matching.

### 7. Application

```bash
curl -vI https://example.com
curl -o /dev/null -s -w "dns:%{time_namelookup} connect:%{time_connect} tls:%{time_appconnect} total:%{time_total}\n" https://example.com
openssl s_client -connect example.com:443 -servername example.com </dev/null
```

The `curl -w` timing breakdown shows where latency is spent: DNS, TCP connect, TLS, or the server.

### 8. Packet capture: ground truth

When the tools disagree, look at the packets:

```bash
sudo tcpdump -i eth0 -nn host example.com and port 443
sudo tcpdump -i any -nn -w capture.pcap      # save for Wireshark
```

**Look for:** SYN packets with no SYN-ACK (dropped), RST packets (rejected), and retransmissions (loss).

### 9. Logs

```bash
journalctl -u NetworkManager -u systemd-networkd -u systemd-resolved --since "1 hour ago"
sudo dmesg -T | grep -iE "eth|link|firmware"
```

These show link flaps, driver or firmware errors, and DHCP failures.

## What you should see

On a healthy machine: interface `UP`, a real IP address, a default route, 0% loss to the gateway and `1.1.1.1`, matching answers from `dig` and `dig @1.1.1.1`, and a `200` from `curl`. Save this output. It's your baseline for comparing against when something breaks.

## Cleanup

```bash
rm -f capture.pcap
```

Undo any breakage you introduced from the list below.

## Next steps

Break one thing at a time on a **VM** (not over SSH to a machine you can't reach physically) and diagnose it using only the commands above:

- **Layer 3:** `sudo ip route del default`. Fix it with `sudo ip route add default via <gateway>`, or by restarting networking.
- **Layer 4 (DNS):** set the DNS server to `192.0.2.1` (an unused documentation address) in NetworkManager, then watch names fail while IPs still work.
- **Layer 6:** `sudo ufw deny out 443/tcp`, then see how `curl` fails. Undo with `sudo ufw delete deny out 443/tcp`.
