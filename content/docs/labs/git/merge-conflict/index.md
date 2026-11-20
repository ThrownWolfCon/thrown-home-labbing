---
title: "Untangle a merge conflict"
linkTitle: "Merge conflicts"
description: "Create a merge conflict on purpose, read the conflict markers, resolve it, and know how to back out instead."
weight: 20
params:
  topic: tutorial
  area: "Git"
  time: "about 15 minutes"
  difficulty: "Beginner"
tags: ["Git"]
---

{{< lab-meta >}}

## Goal

Create a merge conflict on purpose, read the conflict markers, resolve it, and know how to back out instead.

## You'll need

- Git 2.23 or later

## Setup

```bash
mkdir -p ~/conflict-lab && cd ~/conflict-lab
git init -b main
printf "port=8080\nlog_level=info\n" > app.conf
git add app.conf && git commit -qm "Initial config"

git switch -c feature
sed -i 's/port=8080/port=9090/' app.conf
git commit -qam "Use port 9090"

git switch main
sed -i 's/port=8080/port=3000/' app.conf
git commit -qam "Use port 3000"
```

Both branches changed the same line in different ways.

## Do it

1. **Merge and hit the conflict:**

    ```bash
    git merge feature
    git status
    cat app.conf
    ```

2. **Back out (option A):**

    ```bash
    git merge --abort
    git status          # clean again
    ```

3. **Resolve it (option B).** Merge again, then edit `app.conf` so it contains only the line you want, with no markers left:

    ```bash
    git merge feature
    nano app.conf
    git add app.conf
    git commit -m "Merge feature: settle on port 9090"
    git log --oneline --graph --all
    ```

## What you should see

The conflicted file looks like this:

```text
<<<<<<< HEAD
port=3000
=======
port=9090
>>>>>>> feature
log_level=info
```

- Between `<<<<<<< HEAD` and `=======`: your current branch (`main`).
- Between `=======` and `>>>>>>> feature`: the incoming branch.
- `log_level=info` sits outside the markers because neither branch changed it. Git only flags lines that both sides changed differently.

After the commit, `git log --graph` shows the two lines of history joining at the merge commit.

{{< callout type="default" >}}
**Pick a side wholesale**

If you know one side is right for a whole file: `git checkout --ours app.conf` or `git checkout --theirs app.conf`, then `git add` it.
{{< /callout >}}

## Cleanup

```bash
cd ~ && rm -rf ~/conflict-lab
```

## Next steps

- Get the same conflict with `git rebase main` from `feature`, and back out with `git rebase --abort`.
- Turn on `git config --global merge.conflictstyle zdiff3` to also see the original line in the markers.
