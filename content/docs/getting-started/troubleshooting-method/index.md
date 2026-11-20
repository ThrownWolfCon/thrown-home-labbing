---
title: "Troubleshooting method"
description: "Every lab on this site practices the same loop."
weight: 20
params:
  topic: concept
---

Every lab on this site practices the same loop. Tools change; the method doesn't.

## 1. Gather context

- What's the symptom, in the user's words and in yours?
- What changed recently? Deploys, updates, config edits, new hardware.
- When did it start, and is it constant or intermittent?
- Who or what is affected: one host or many, one user or all?
- Which versions and environment are involved?

## 2. Gather evidence

- Logs (`journalctl`, application logs)
- Configuration as it's actually loaded, not as you remember it (`systemctl cat`, `git config --list --show-origin`)
- Exact error text or screenshots
- Ideally, a way to reproduce it

## 3. Narrow it down

Split the problem into layers and rule them out one at a time: network, configuration, authentication, licensing, the software itself. For network problems, go [layer by layer]({{< ref "/docs/labs/networking/layered-troubleshooting" >}}), bottom up or top down, or divide and conquer from the middle.

## 4. Form a hypothesis and test it

Start with the most likely cause or the cheapest check. Change **one thing at a time** and confirm the result before moving on. If the theory doesn't hold, form a new one or escalate.

## 5. Fix and verify

Confirm the whole thing works, not just that the error message went away. If it's someone else's problem, confirm with them.

## 6. Document

Write down what you found, what you did, and what happened. If it's likely to come up again, turn it into a knowledge base article, or a lab on this site.

{{< callout type="info" >}}
**Where this comes from**

This lines up with the CompTIA Network+ troubleshooting methodology (objective 5.1) and with how most support teams expect tickets to be worked.
{{< /callout >}}
