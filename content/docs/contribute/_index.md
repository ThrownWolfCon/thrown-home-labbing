---
title: "Contribute"
description: "How to set up, make a change, and get it onto the site."
weight: 90
params:
  topic: section
---

This site is docs-as-code: Markdown in Git, changes through pull requests, and automated checks on every change. It uses the same tools and conventions as the Grafana Labs and GitLab documentation teams.

**New here?** Start with the first page and go in order. Every step says what to type and what you should see.

{{< cards >}}
  {{< card link="set-up-ubuntu" title="1. Set up your computer" icon="desktop-computer" subtitle="Install the tools, download the project, and see the site running locally." >}}
  {{< card link="make-a-change" title="2. Make a change" icon="pencil" subtitle="Branch, edit, check, push, open a pull request, and merge." >}}
  {{< card link="troubleshooting" title="When something goes wrong" icon="support" subtitle="Common errors, what they mean, and how to fix them." >}}
{{< /cards >}}

## Reference

{{< cards >}}
  {{< card link="lab-template" title="Lab template" icon="document-text" subtitle="Front matter and sections for a new lab." >}}
  {{< card link="style-and-linting" title="Style and linting" icon="check-circle" subtitle="The style guide, Vale, and markdownlint." >}}
{{< /cards >}}

## How the site is built

| Piece | Tool |
| --- | --- |
| Static site generator | [Hugo]({{< ref "/docs/tools/hugo" >}}), with the [Hextra](https://imfing.github.io/hextra/) theme as a Hugo module |
| Content | Markdown page bundles under `content/docs/` |
| Prose linting | [Vale]({{< ref "/docs/tools/vale" >}}) with the Grafana Labs Writers' Toolkit style |
| Markdown linting | [markdownlint-cli2]({{< ref "/docs/tools/markdownlint" >}}) |
| Hosting | GitHub Pages, deployed by [GitHub Actions]({{< ref "/docs/tools/github-actions" >}}) |

For every tool, including how to check, install, update, and remove it, refer to [Docs-as-code tools]({{< ref "/docs/tools" >}}).
