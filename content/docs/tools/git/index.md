---
title: "Git"
description: "Git tracks every change to the site and sends your changes to GitHub."
weight: 10
params:
  topic: reference
---

**Git** is a version control system. It records every change to every file, so you can see what changed, go back to an earlier version, and work on a copy (a *branch*) without touching the live site.

## What it does in this project

- Downloads the project to your computer (`git clone`).
- Saves your changes as *commits* (`git commit`).
- Sends your branch to GitHub (`git push`) so you can open a pull request.
- Records the date each page last changed. Hugo reads this to show **Last updated** at the bottom of every page.

## Check if it's installed

```bash
git --version
which git
```

**You should see:** a version such as `git version 2.48.1`, and a path such as `/usr/bin/git`.

**Not installed?** You'll see `Command 'git' not found`. Follow [Install](#install).

## Install

```bash
sudo apt update
sudo apt install -y git
git --version
```

Then tell Git who you are. It puts this on every commit. Use the email on your GitHub account:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Check what's set, and which file each setting comes from:

```bash
git config --list --show-origin
```

## Update

```bash
sudo apt update
sudo apt install --only-upgrade -y git
```

## Remove

{{< callout type="warning" >}}
**Your projects stay, but you can't work on them**

Removing Git doesn't delete any project folders. You just can't commit, push, or pull until you install it again.
{{< /callout >}}

```bash
sudo apt remove -y git
```

Your settings stay in `~/.gitconfig`. Delete that file too for a completely fresh start.

## Commands you'll use

| Command | What it does |
| --- | --- |
| `git status` | Shows what's changed and which branch you're on |
| `git switch main` | Goes to the `main` branch |
| `git switch -c my-change` | Makes a new branch and goes to it |
| `git pull` | Gets the latest changes from GitHub |
| `git add <file>` | Marks a file to include in the next commit |
| `git commit -m "Message"` | Saves the marked changes with a message |
| `git push` | Sends your commits to GitHub |
| `git log --oneline -10` | Shows the last 10 commits |
| `git diff` | Shows exactly what changed, line by line |
| `git restore <file>` | Throws away your unsaved edits to a file |

## Files in this project

| File | What it's for |
| --- | --- |
| `.gitignore` | Files Git should never track, such as the built site in `public/` |
| `.git/` | The Git database for this project. Don't edit it by hand. |

## Official documentation

- [Git documentation](https://git-scm.com/doc)
- [Pro Git book](https://git-scm.com/book/en/v2), free online
- [Git guides from GitHub](https://github.com/git-guides)

## Related pages

- [Make a change, step by step]({{< ref "/docs/contribute/make-a-change" >}})
- [Troubleshooting: Work with Git]({{< ref "/docs/contribute/troubleshooting#work-with-git" >}})
- Labs: [Recover lost commits with reflog]({{< ref "/docs/labs/git/reflog-recovery" >}}) and [Untangle a merge conflict]({{< ref "/docs/labs/git/merge-conflict" >}})
