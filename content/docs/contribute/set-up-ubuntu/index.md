---
title: "Set up your computer (Ubuntu)"
linkTitle: "Set up on Ubuntu"
description: "Install the tools, download the project, and see the site running on your own computer."
weight: 5
params:
  topic: task
---

This page takes you from nothing installed to the site running in your browser. Do the steps in order. Each step tells you what to type and what you should see.

**Time:** about 20 minutes, once. After that, you only need [Step 8](#step-8-see-the-site).

{{< callout type="info" >}}
**How to use the commands on this page**

- Copy each grey box, paste it into the terminal with **Ctrl+Shift+V**, and press **Enter**.
- `sudo` asks for your computer password. Nothing appears while you type it. That's normal. Type it and press **Enter**.
- If anything doesn't match **You should see**, stop and check [When something goes wrong]({{< ref "/docs/contribute/troubleshooting" >}}).
{{< /callout >}}

## Before you begin

- A computer running Ubuntu 24.04 or later.
- A GitHub account. If the repository isn't yours, you also need your own copy of it, called a *fork*. Open the repository on GitHub and click **Fork**.
- A terminal. Press **Ctrl+Alt+T** to open one.

## Step 1: Update the package list

```bash
sudo apt update
```

**You should see:** a list of lines ending with something like `All packages are up to date` or `N packages can be upgraded`. Either is fine.

## Step 2: Install Git, Make, and Go

- **Git** downloads the project and tracks your changes.
- **Make** runs the shortcuts in the project's `Makefile`, such as `make serve`.
- **Go** lets Hugo download the site's theme.

```bash
sudo apt install -y git make golang-go
```

Check that they installed:

```bash
git --version
make --version | head -1
go version
```

**You should see:** three version lines, for example `git version 2.48.1`, `GNU Make 4.4.1`, and `go version go1.26`. Your numbers can differ.

## Step 3: Install Hugo

Hugo turns the Markdown files into the website. Install the same version the website build uses.

{{< callout type="warning" >}}
**Don't use `sudo apt install hugo`**

Ubuntu's own Hugo package is often too old for this site's theme. Use the commands below instead.
{{< /callout >}}

```bash
cd /tmp
wget https://github.com/gohugoio/hugo/releases/download/v0.170.1/hugo_extended_0.170.1_linux-amd64.deb
sudo apt install -y ./hugo_extended_0.170.1_linux-amd64.deb
cd ~
hugo version
```

**You should see:** a line that starts with `hugo v0.170.1` and includes the word `extended`.

## Step 4: Install Vale

Vale checks your writing against the Grafana Labs style guide.

```bash
cd /tmp
wget https://github.com/errata-ai/vale/releases/download/v3.28.1/vale_3.28.1_Linux_64-bit.tar.gz
tar xzf vale_3.28.1_Linux_64-bit.tar.gz vale
sudo mv vale /usr/local/bin/
cd ~
vale --version
```

**You should see:** `vale version 3.28.1`.

## Step 5: Install Node.js

markdownlint, the tool that checks Markdown formatting, runs on Node.js.

```bash
sudo apt install -y nodejs npm
node --version
```

**You should see:** a version line such as `v20.19.2`.

## Step 6: Tell Git who you are

Git puts your name and email on every change you save. Use the email address on your GitHub account.

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

**You should see:** nothing. No output means it worked.

## Step 7: Download the project

This makes a folder called `thrown-home-labbing` in your home folder. If you made a fork, replace `ThrownWolfCon` with your GitHub username.

```bash
cd ~
git clone https://github.com/ThrownWolfCon/thrown-home-labbing.git
cd thrown-home-labbing
ls
```

**You should see:** `Makefile  README.md  content  go.mod  go.sum  hugo.toml  layouts`.

{{< callout type="default" >}}
**Hidden files are there too**

`ls` hides names that start with a dot, like `.github` and `.vale.ini`. To see them, use `ls -a`.
{{< /callout >}}

## Step 8: See the site

```bash
cd ~/thrown-home-labbing
make serve
```

The first time takes a minute while Hugo downloads the theme.

**You should see:** a block of text ending with:

```text
Web Server is available at http://localhost:1313/thrown-home-labbing/ (bind address 127.0.0.1)
Press Ctrl+C to stop
```

Open <http://localhost:1313/thrown-home-labbing/> in your browser. That's the site, running on your computer.

Leave the terminal open. When you save a change to a file in `content/`, the browser page updates by itself.

To stop the server, click in the terminal and press **Ctrl+C**.

## Step 9: Set up the writing checker (once)

This downloads the Grafana style rules that Vale uses. Open a **second** terminal tab with **Ctrl+Shift+T** so the site can keep running in the first one.

```bash
cd ~/thrown-home-labbing
make vale-sync
make lint
```

**You should see:** two results, one from each checker:

```text
✔ 0 errors, 0 warnings and 0 suggestions in 39 files.
...
Summary: 0 issues in 0 files
```

The file counts can differ. What matters is **0 errors** and **0 issues**.

## Checklist

- [ ] `hugo version` shows `v0.170.1` and `extended`
- [ ] `vale --version` shows `3.28.1`
- [ ] `make serve` shows the site at <http://localhost:1313/thrown-home-labbing/>
- [ ] `make lint` shows 0 errors and 0 issues

All checked? You're ready to [make a change]({{< ref "/docs/contribute/make-a-change" >}}).
