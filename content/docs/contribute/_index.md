---
title: "Contribute"
description: "How this site is built, written, and checked."
weight: 90
params:
  topic: section
---

This site is docs-as-code: Markdown in Git, changes through pull requests, and automated checks on every change. It uses the same tools and conventions as the Grafana Labs and GitLab documentation teams.

{{< cards >}}
  {{< card link="lab-template" title="Lab template" icon="document-text" subtitle="Front matter and sections for a new lab." >}}
  {{< card link="style-and-linting" title="Style and linting" icon="check-circle" subtitle="The style guide, Vale, and markdownlint." >}}
{{< /cards >}}

## How the site is built

| Piece | Tool |
| --- | --- |
| Static site generator | [Hugo](https://gohugo.io/), with the [Hextra](https://imfing.github.io/hextra/) theme as a Hugo module |
| Content | Markdown page bundles under `content/docs/` |
| Prose linting | [Vale](https://vale.sh/) with the Grafana Labs Writers' Toolkit style |
| Markdown linting | [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2) |
| Hosting | GitHub Pages, deployed by GitHub Actions |

## Workflow

1. Create a branch.
1. Add or edit a page. Preview with `hugo server`.
1. Run `make lint` and fix what it reports.
1. Open a pull request. The **Lint** workflow runs the same checks.
1. Merge to `main`. The **Deploy** workflow publishes the site.
