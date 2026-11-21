---
title: "Style and linting"
description: "The style guide this site follows and the linters that check it."
weight: 20
params:
  topic: reference
---

## Style guide

This site follows the [Grafana Labs Writers' Toolkit](https://grafana.com/docs/writers-toolkit/), with a few site-specific conventions:

- Placeholders use angle brackets: `<host>`, `<your-username>`.
- Examples use `example.com` and documentation IP ranges such as `192.0.2.0/24`, never real hosts.
- Sample prompts use `you@homelab:~$`.
- Never paste API keys, tokens, or `.env` contents into a page, even in sample output.

## Linters

| Linter | Checks | Configuration |
| --- | --- | --- |
| [Vale]({{< ref "/docs/tools/vale" >}}) | Word choice, tone, spelling, and headings, using the Grafana style | `.vale.ini` and `.vale/` |
| [markdownlint-cli2]({{< ref "/docs/tools/markdownlint" >}}) | Markdown structure, such as heading levels and list formatting | `.markdownlint-cli2.yaml` |

Run both locally:

```bash
make lint
```

The **Lint** workflow runs the same checks on every pull request.

### Add a word to the vocabulary

If Vale flags a correct technical term as a spelling error, add it to `.vale/styles/config/vocabularies/Thrown/accept.txt`, one term per line. Prefer code font for commands and filenames: Vale ignores text in backticks.

### Turn off a rule for one passage

Use this only when the rule is wrong for that passage:

```markdown
<!-- vale Grafana.Headings = NO -->
## A heading the rule gets wrong
<!-- vale Grafana.Headings = YES -->
```
