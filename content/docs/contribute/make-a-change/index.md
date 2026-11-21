---
title: "Make a change, step by step"
linkTitle: "Make a change"
description: "Edit a page, check it, and get it onto the live site through a pull request."
weight: 6
params:
  topic: task
---

This page walks through one complete change, from editing a file to seeing it on the live site. It's the same workflow technical writers use at GitLab and Grafana Labs.

**Time:** about 15 minutes the first time.

## Before you begin

- Finish [Set up your computer]({{< ref "/docs/contribute/set-up-ubuntu" >}}).
- Know which file you want to change. Website pages are in `content/docs/`. The repository's front page on GitHub is `README.md`.

## The big picture

```text
main branch (the live site)
   │
   ├── 1. make your own branch
   │        2. edit files
   │        3. check your work
   │        4. save (commit)
   │        5. upload (push)
   │
   └── 6. pull request ──▶ checks run ──▶ 7. merge ──▶ site updates
```

You never edit `main` directly. You work on your own *branch*, a private copy of the project. When it's ready, you ask to merge it into `main` with a *pull request*.

## Step 1: Get the latest version

Someone, maybe you on another day, might have changed things since you last looked.

```bash
cd ~/thrown-home-labbing
git switch main
git pull
```

**You should see:** `Already up to date.`, or a list of files that changed.

## Step 2: Make a branch

Name the branch after what you're doing. Use lowercase words joined by hyphens.

```bash
git switch -c improve-readme
```

**You should see:** `Switched to a new branch 'improve-readme'`.

{{< callout type="default" >}}
**Not sure which branch you're on?**

Run `git branch`. The one with the `*` is your current branch.
{{< /callout >}}

## Step 3: Edit the file

Open the project in your editor. For VS Code:

```bash
code .
```

Make your change and save the file with **Ctrl+S**.

**To preview your change:**

- **A page in `content/`:** run `make serve` and look at <http://localhost:1313/thrown-home-labbing/>. The page updates each time you save.
- **`README.md`:** in VS Code, press **Ctrl+Shift+V** to see it the way GitHub shows it.

## Step 4: Check your work

```bash
make lint
```

**You should see:** `0 errors` from [Vale]({{< ref "/docs/tools/vale" >}}) and `0 issues` from [markdownlint]({{< ref "/docs/tools/markdownlint" >}}).

If it reports problems, each line tells you the file, the line number, and what to change:

```text
content/docs/labs/linux/my-lab/index.md
 12:5  error  Use 'refer to' instead of 'see'.  Grafana.ReferTo
```

That means: in that file, on line 12, at character 5, change "see" to "refer to". Fix it, save, and run `make lint` again until it's clean.

## Step 5: Save your change in Git (commit)

First, look at what changed:

```bash
git status
```

**You should see:** your file listed in red under `Changes not staged for commit`.

Now save it. The message in quotes says what you did, in a few words:

```bash
git add README.md
git commit -m "Spell out the setup steps in the README"
```

Replace `README.md` with your file's path. To add every changed file at once, use `git add .`, but run `git status` first so you know what that includes.

**You should see:** `1 file changed`, plus a count of lines added and removed.

## Step 6: Upload your branch (push)

```bash
git push -u origin improve-readme
```

Use your branch name. The `-u` is only needed the first time you push a branch. After that, plain `git push` works.

**You should see:** a few lines ending with a link like `https://github.com/ThrownWolfCon/thrown-home-labbing/pull/new/improve-readme`.

## Step 7: Open a pull request

1. Open the link from Step 6, or go to the repository on GitHub and click the yellow **Compare & pull request** button.
1. Check the title. Add a sentence or two in the description about what you changed and why.
1. Click **Create pull request**.

GitHub starts the **Lint** checks. Wait a minute or two.

**You should see:** a green check mark next to **All checks have passed**.

{{< callout type="warning" >}}
**A red X instead?**

Click **Details** next to the failed check to see the error. Fix it on your computer, then repeat Steps 4 to 6. The pull request updates by itself when you push, and the checks run again.
{{< /callout >}}

## Step 8: Merge

When the checks are green:

1. Click **Merge pull request**, then **Confirm merge**.
1. Click **Delete branch**. Your change is safe in `main`, so the branch isn't needed anymore.

The **Deploy** workflow publishes the site. In about a minute, your change is live at <https://thrownwolfcon.github.io/thrown-home-labbing/>.

## Step 9: Clean up on your computer

Go back to `main`, get your merged change, and delete the old branch:

```bash
git switch main
git pull
git branch -d improve-readme
```

**You should see:** `Deleted branch improve-readme`.

You're back where you started, ready for the next change.

## Quick reference

After the steps feel familiar, this table is all of it:

| Step | Command |
| --- | --- |
| 1. Get the latest | `git switch main && git pull` |
| 2. New branch | `git switch -c my-change` |
| 3. Edit and preview | Edit the file, then `make serve` |
| 4. Check | `make lint` |
| 5. Commit | `git add . && git commit -m "What I did"` |
| 6. Push | `git push -u origin my-change` |
| 7. Pull request | Open it on GitHub and wait for the green check |
| 8. Merge | **Merge pull request**, then **Delete branch** |
| 9. Clean up | `git switch main && git pull && git branch -d my-change` |
