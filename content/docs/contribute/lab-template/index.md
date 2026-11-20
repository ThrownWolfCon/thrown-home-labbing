---
title: "Lab template"
description: "Copy this template to start a new lab."
weight: 10
params:
  topic: reference
---

Every lab is a tutorial topic: it walks the reader through a complete task from start to finish. Copy the template into a new page bundle, for example `content/docs/labs/linux/my-new-lab/index.md`.

## Front matter

| Field | Required | What it does |
| --- | --- | --- |
| `title` | Yes | The page heading. Start with a verb: "Debug a failing service." |
| `linkTitle` | No | A shorter title for the sidebar. |
| `description` | Yes | One sentence. Appears in search results and the lab index. |
| `weight` | Yes | Order within the area. Use steps of 10 so you can insert labs later. |
| `params.topic` | Yes | `tutorial` for labs. The lab index lists only tutorial pages. |
| `params.area` | Yes | Shown in the badge row. |
| `params.time` | Yes | For example, `about 20 minutes`. |
| `params.difficulty` | Yes | `Beginner`, `Intermediate`, or `Advanced`. |
| `tags` | Yes | One tag for the area. |

## Template

````markdown
---
title: "<Verb phrase, like Debug a failing service>"
linkTitle: "<Short sidebar title>"
description: "<One sentence: the skill this keeps sharp.>"
weight: <10, 20, 30...>
params:
  topic: tutorial
  area: "<Linux & systemd | Networking | Storage | Containers | Git | Security & access | Observability>"
  time: "about <N> minutes"
  difficulty: "<Beginner | Intermediate | Advanced>"
tags: ["<Area>"]
---

{{</* lab-meta */>}}

## Goal

<One or two sentences: the skill this keeps sharp.>

## You'll need

- <Packages, sudo, earlier labs>

## Setup

```bash
<Commands that build the scenario. Never edit existing system config.>
```

## Do it

<The exercise. Prefer "break it, then investigate."
Number the steps. Ask the reader to predict before revealing.>

## What you should see

```text
<Sample output, sanitized: you@homelab, example.com, 192.0.2.x>
```

<How to read it: what each important line means.>

## Cleanup

```bash
<Commands that undo everything in Setup and Do it.>
```

## Next steps

- <A harder variation>
- <A related tool or concept>
````

## Callouts

Use the theme's `callout` shortcode for tips and warnings:

```markdown
{{</* callout type="warning" */>}}
**Don't lock yourself out**

Test the new login in a separate terminal before you close your session.
{{</* /callout */>}}
```

Types: `default` (tip), `info` (note), `warning`, and `error` (danger).
