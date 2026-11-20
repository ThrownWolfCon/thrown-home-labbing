---
title: "Recover \"lost\" commits with reflog"
linkTitle: "Reflog recovery"
description: "Lose work the way people actually lose it (a hard reset, a deleted branch) and get it back with the Git reflog."
weight: 10
params:
  topic: tutorial
  area: "Git"
  time: "about 15 minutes"
  difficulty: "Beginner"
tags: ["Git"]
---

{{< lab-meta >}}

## Goal

Lose work the way people actually lose it (a hard reset, a deleted branch) and get it back with the Git reflog.

## You'll need

- Git 2.23 or later (`git --version`)

## Setup

```bash
mkdir -p ~/git-lab && cd ~/git-lab
git init -b main
for n in 1 2 3; do echo "line $n" >> notes.txt; git add notes.txt; git commit -qm "Add line $n"; done
git log --oneline --graph --all
```

## Do it

1. **Lose commits with a hard reset:**

    ```bash
    git reset --hard HEAD~2
    git log --oneline          # "Add line 2" and "Add line 3" are gone
    cat notes.txt
    ```

2. **Find them in the reflog:**

    ```bash
    git reflog
    ```

3. **Get them back.** Use the hash next to `commit: Add line 3`:

    ```bash
    git reset --hard <sha>
    git log --oneline
    ```

4. **Lose a whole branch:**

    ```bash
    git switch -c experiment
    echo "risky idea" > idea.txt && git add idea.txt && git commit -qm "Risky idea"
    git switch main
    git branch -D experiment
    ```

5. **Rescue it to a new branch:**

    ```bash
    git reflog | grep "Risky idea"
    git switch -c rescue <sha>
    ls
    ```

## What you should see

`git reflog` lists every place `HEAD` has been, newest first:

```text
a1b2c3d HEAD@{0}: reset: moving to HEAD~2
f6e5d4c HEAD@{1}: commit: Add line 3
9a8b7c6 HEAD@{2}: commit: Add line 2
```

Commits aren't deleted when nothing points to them. They stay in the repository until garbage collection removes them, by default after at least 30 days for unreachable commits. The reflog is your map back to them.

### Undo cheat sheet

| Situation | Command |
| --- | --- |
| Bad commit, not pushed, keep the changes | `git reset --soft HEAD~1` |
| Fix the last commit message or add a forgotten file | `git commit --amend` |
| Discard local edits to a file | `git restore <file>` |
| Unstage a file | `git restore --staged <file>` |
| Undo a commit that's already pushed | `git revert <sha>` (makes a new commit, doesn't rewrite history) |
| Detached HEAD with work you want to keep | `git switch -c <new-branch>` |

{{< callout type="warning" >}}
The reflog is local. It can't recover something that was never committed, and it doesn't exist in a fresh clone.
{{< /callout >}}

## Cleanup

```bash
cd ~ && rm -rf ~/git-lab
```

## Next steps

- Recover from a bad `git rebase` with `git reset --hard ORIG_HEAD`.
- See the reflog for one branch: `git reflog show main`.
- Diagnose config problems with `git config --list --show-origin`, or see what Git is doing with `GIT_TRACE=1 git status`.
