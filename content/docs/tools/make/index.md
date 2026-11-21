---
title: "Make"
description: "Make runs the project's shortcuts, like make serve and make lint."
weight: 20
params:
  topic: reference
---

**Make** runs named tasks from a file called `Makefile`. Instead of remembering a long command, you type a short name such as `make serve`.

## What it does in this project

The project's `Makefile` defines these shortcuts:

| You type | What actually runs |
| --- | --- |
| `make help` | Lists all the shortcuts |
| `make serve` | `hugo server --buildDrafts`: previews the site |
| `make build` | `hugo --gc --minify`: builds the site into `public/` |
| `make vale-sync` | Downloads the Grafana style rules for Vale |
| `make vale` | `vale content/`: checks writing style |
| `make markdownlint` | `npx markdownlint-cli2 ...`: checks Markdown formatting |
| `make lint` | Runs `make vale`, then `make markdownlint` |

Make doesn't do the work itself. It calls [Hugo]({{< ref "/docs/tools/hugo" >}}), [Vale]({{< ref "/docs/tools/vale" >}}), and [markdownlint]({{< ref "/docs/tools/markdownlint" >}}), so those need to be installed too.

## Check if it's installed

```bash
make --version | head -1
which make
```

**You should see:** a version such as `GNU Make 4.4.1`, and a path such as `/usr/bin/make`.

## Install

```bash
sudo apt update
sudo apt install -y make
make --version | head -1
```

## Update

```bash
sudo apt update
sudo apt install --only-upgrade -y make
```

## Remove

{{< callout type="warning" >}}
**Other software may need Make**

Many build tools depend on Make. `apt` lists anything else it would remove, so read that list before you type `y`.
{{< /callout >}}

```bash
sudo apt remove make
```

## How to read the Makefile

Open `Makefile` in any text editor. Each shortcut looks like this:

```makefile
serve: ## Preview the site at http://localhost:1313 with live reload
	hugo server --buildDrafts
```

- `serve:` is the name you type after `make`.
- The text after `##` is the description that `make help` shows.
- The indented line is the command that runs. It **must** start with a Tab character, not spaces.

## Errors you might see

| Error | Meaning |
| --- | --- |
| `make: <tool>: No such file or directory` and `Error 127` | The tool Make tried to run isn't installed |
| `No rule to make target 'serve'` | You're not in the project folder, or the shortcut name is wrong |
| `missing separator` | A command line starts with spaces instead of a Tab |

## Official documentation

- [GNU Make manual](https://www.gnu.org/software/make/manual/)

## Related pages

- [Troubleshooting: Run the site]({{< ref "/docs/contribute/troubleshooting#run-the-site" >}})
