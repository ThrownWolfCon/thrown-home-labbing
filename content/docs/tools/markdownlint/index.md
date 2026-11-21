---
title: "markdownlint and Node.js"
linkTitle: "markdownlint"
description: "markdownlint checks Markdown formatting. It runs on Node.js."
weight: 60
params:
  topic: reference
---

**markdownlint** checks how Markdown is *written*, not what it says. It catches things like skipped heading levels, inconsistent list markers, and code blocks without a language. This project uses the `markdownlint-cli2` version of it.

**Node.js** is a program that runs JavaScript outside a web browser. markdownlint is written in JavaScript, so it needs Node.js. Node.js comes with `npx`, which downloads and runs a tool in one step.

## What it does in this project

- `make markdownlint` and `make lint` run `npx --yes markdownlint-cli2 "content/**/*.md"`.
- `npx` downloads markdownlint the first time and keeps a copy for next time. You never install markdownlint itself.
- The **Lint** workflow runs the same check on GitHub.

## Check if it's installed

```bash
node --version
npx --version
```

**You should see:** a Node.js version of `v22` or later, such as `v22.14.0`, and an `npx` version such as `10.9.2`.

{{< callout type="warning" >}}
**Node.js must be version 22 or later**

markdownlint-cli2 needs Node.js 22 or newer. If `node --version` shows `v20` or lower, follow [Install a newer Node.js](#install-a-newer-nodejs).
{{< /callout >}}

To check markdownlint itself:

```bash
npx --yes markdownlint-cli2 --help | head -1
```

**You should see:** a line that starts with `markdownlint-cli2 v0.`, such as `markdownlint-cli2 v0.24.2`.

## Install

On Ubuntu 24.04 and later, Ubuntu's own Node.js is new enough:

```bash
sudo apt update
sudo apt install -y nodejs npm
node --version
```

### Install a newer Node.js

Older Ubuntu releases ship an older Node.js. To get a current one, use the NodeSource repository. Remove Ubuntu's version first so the two don't conflict:

```bash
sudo apt remove -y nodejs npm
cd /tmp
curl -fsSL https://deb.nodesource.com/setup_24.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt install -y nodejs
cd ~
node --version
```

**You should see:** `v24` followed by more numbers. NodeSource's package includes `npm` and `npx`, so don't install `npm` separately.

## Update

Node.js updates with the rest of your system:

```bash
sudo apt update
sudo apt upgrade -y nodejs
```

markdownlint updates by itself: `npx` checks for the newest version when it runs.

## Remove

```bash
sudo apt remove -y nodejs npm
sudo apt autoremove -y
```

To clear `npx`'s saved copy of markdownlint:

```bash
rm -rf ~/.npm/_npx
```

## Commands you'll use

| Command | What it does |
| --- | --- |
| `make markdownlint` | Checks every page |
| `npx markdownlint-cli2 "content/docs/labs/**/*.md"` | Checks only the labs |
| `npx markdownlint-cli2 --fix "content/**/*.md"` | Fixes what it can automatically. Review the changes with `git diff`. |

## How to read the markdownlint output

```text
content/docs/labs/git/merge-conflict/index.md:42 error MD032/blanks-around-lists Lists should be surrounded by blank lines
```

| Part | Meaning |
| --- | --- |
| `index.md:42` | The file and line number |
| `MD032` | The rule number. Look it up in the [rules list](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md). |
| The message | What's wrong. Here, the list needs an empty line before it. |

## Files in this project

| File | What it's for |
| --- | --- |
| `.markdownlint-cli2.yaml` | Which rules are on or off, and why |

## Official documentation

- [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2)
- [markdownlint rules](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md)
- [Node.js documentation](https://nodejs.org/docs/latest/api/)
- [NodeSource distributions](https://github.com/nodesource/distributions)

## Related pages

- [Style and linting]({{< ref "/docs/contribute/style-and-linting" >}})
