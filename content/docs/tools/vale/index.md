---
title: "Vale"
description: "Vale checks the writing on every page against the Grafana Labs style guide."
weight: 50
params:
  topic: reference
---

**Vale** is a *prose linter*: a tool that checks writing the way a spell checker does, but against a whole style guide. It flags things like "see" where the style guide says "refer to," headings in the wrong case, and words that aren't in its dictionary. Grafana Labs, GitLab, and many other documentation teams use it.

## What it does in this project

- Checks every Markdown file in `content/` against the [Grafana Labs Writers' Toolkit](https://grafana.com/docs/writers-toolkit/) style.
- Runs on your computer with `make vale` or `make lint`.
- Runs on GitHub in the **Lint** workflow on every push and pull request.

## Check if it's installed

```bash
vale --version
which vale
```

**You should see:** `vale version 3.28.1` or later, and the path `/usr/local/bin/vale`.

To check that the Grafana style rules are downloaded:

```bash
cd ~/thrown-home-labbing
ls .vale/styles
```

**You should see:** `Grafana` and `config`. If you only see `config`, run `make vale-sync`.

## Install

```bash
cd /tmp
wget https://github.com/errata-ai/vale/releases/download/v3.28.1/vale_3.28.1_Linux_64-bit.tar.gz
tar xzf vale_3.28.1_Linux_64-bit.tar.gz vale
sudo mv vale /usr/local/bin/
cd ~
vale --version
```

Then download the style rules, once per copy of the project:

```bash
cd ~/thrown-home-labbing
make vale-sync
```

## Update

1. Find the newest version on the [Vale releases page](https://github.com/errata-ai/vale/releases).
1. Run the [Install](#install) commands again with the new version number in both places.
1. Update the version the website build uses. In `.github/workflows/lint.yml`, change this line:

    ```yaml
    VALE_VERSION: 3.28.1
    ```

To get the latest Grafana style rules, run `make vale-sync` again.

## Remove

```bash
sudo rm /usr/local/bin/vale
```

To also remove the downloaded style rules from the project:

```bash
cd ~/thrown-home-labbing
rm -rf .vale/styles/Grafana .vale/styles/config/dictionaries .vale/styles/config/scripts
```

That leaves `.vale/styles/config/vocabularies/`, which is part of the project and tracked by Git.

## Commands you'll use

| Command | What it does |
| --- | --- |
| `vale content/` | Checks every page |
| `vale content/docs/labs/git/` | Checks only one folder |
| `vale path/to/index.md` | Checks one file |
| `vale sync` | Downloads the packages listed in `.vale.ini` |
| `vale ls-config` | Shows the settings Vale is actually using |
| `vale ls-dirs` | Shows where Vale looks for its files |

## How to read the Vale output

```text
content/docs/labs/linux/my-lab/index.md
 12:5  warning  Use 'refer to' instead of 'see'.  Grafana.ReferTo
```

| Part | Meaning |
| --- | --- |
| `12:5` | Line 12, character 5 |
| `warning` | How serious it is: `suggestion`, `warning`, or `error` |
| The message | What to change |
| `Grafana.ReferTo` | The rule's name. Search for it in the [Writers' Toolkit](https://grafana.com/docs/writers-toolkit/) to learn why. |

## Files in this project

| File or folder | What it's for |
| --- | --- |
| `.vale.ini` | Vale's settings: which style to use and what to ignore |
| `.vale/styles/config/vocabularies/Thrown/accept.txt` | Words Vale should accept as correctly spelled, one per line |
| `.vale/styles/Grafana/` | The Grafana rules. Downloaded by `make vale-sync`, not tracked by Git. |

## Official documentation

- [Vale documentation](https://vale.sh/docs/)
- [Grafana Labs Writers' Toolkit](https://grafana.com/docs/writers-toolkit/)

## Related pages

- [Style and linting]({{< ref "/docs/contribute/style-and-linting" >}})
- [Troubleshooting: Vale reports a style error]({{< ref "/docs/contribute/troubleshooting#vale-reports-a-style-error" >}})
