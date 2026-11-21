---
title: "Docs-as-code tools"
linkTitle: "Tools"
description: "Every tool this site uses: what it does, how to check it's installed, and how to install, update, or remove it."
weight: 80
params:
  topic: section
---

*Docs-as-code* means treating documentation the way developers treat code: plain-text files in Git, changes reviewed in pull requests, and automated checks before anything goes live. These are the tools that make that work for this site.

Each tool has its own page with the same sections: what it does here, how to check it, and how to install, update, or remove it, plus links to its official documentation.

## How the tools fit together

```text
 You write Markdown ──▶ Vale checks the writing
        │               markdownlint checks the formatting
        │
        ▼
 Git saves the change ──▶ GitHub (pull request)
                                │
                                ▼
                        GitHub Actions runs the same checks
                                │
                                ▼
                        Hugo builds the site ──▶ GitHub Pages
```

Make runs the shortcuts (`make serve`, `make lint`), and Go lets Hugo download the theme.

## All tools at a glance

| Tool | What it does | Check it's installed | Needed on your computer? |
| --- | --- | --- | --- |
| [Git]({{< ref "/docs/tools/git" >}}) | Tracks changes and talks to GitHub | `git --version` | Yes |
| [Make]({{< ref "/docs/tools/make" >}}) | Runs shortcuts like `make serve` | `make --version` | Yes |
| [Go]({{< ref "/docs/tools/go" >}}) | Lets Hugo download the theme | `go version` | Yes |
| [Hugo]({{< ref "/docs/tools/hugo" >}}) | Turns Markdown into the website | `hugo version` | Yes |
| [Vale]({{< ref "/docs/tools/vale" >}}) | Checks writing style | `vale --version` | For `make lint` |
| [markdownlint and Node.js]({{< ref "/docs/tools/markdownlint" >}}) | Checks Markdown formatting | `node --version` | For `make lint` |
| [GitHub Actions]({{< ref "/docs/tools/github-actions" >}}) | Runs checks and publishes the site | The **Actions** tab on GitHub | No, it runs on GitHub |

## Check everything at once

Copy this whole block into a terminal. Each line prints a version, or `not installed`.

```bash
for tool in git make go hugo vale node; do
  printf '%-6s ' "$tool"
  if command -v "$tool" > /dev/null; then
    case "$tool" in
      go|hugo) "$tool" version ;;
      *) "$tool" --version ;;
    esac | head -1
  else
    echo "not installed"
  fi
done
```

**You should see:** something like this. Your version numbers can differ, but Hugo should be `v0.170.1` or later, and Node.js should be `v22` or later.

```text
git    git version 2.48.1
make   GNU Make 4.4.1
go     go version go1.26.0 linux/amd64
hugo   hugo v0.170.1-c8b03de9... linux/amd64 BuildDate=... VendorInfo=gohugoio
vale   vale version 3.28.1
node   v22.14.0
```

Anything that says `not installed`? Open that tool's page and follow **Install**.

{{< callout type="info" >}}
**Hugo doesn't print "extended"**

Recent Hugo releases don't show the word `extended` in the version line, even for the extended edition. If you installed the `hugo_extended` package from the [Hugo page]({{< ref "/docs/tools/hugo#install" >}}), you have the right one.
{{< /callout >}}
