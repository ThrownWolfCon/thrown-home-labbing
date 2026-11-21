---
title: "When something goes wrong"
linkTitle: "Troubleshooting"
description: "Common errors while setting up or contributing, what they mean, and how to fix them."
weight: 7
params:
  topic: reference
---

Find the error message you got, then follow the fix. Every one of these has happened to someone working on this site.

{{< callout type="default" >}}
**Read the last line first**

Error output can be long. The useful part is usually the last line or two.
{{< /callout >}}

## Run the site

### `make: hugo: No such file or directory` and `Error 127`

**What it means:** Hugo isn't installed, or your terminal can't find it. Error 127 always means "command not found."

**Fix:** install Hugo. Follow [Step 3 of the setup]({{< ref "/docs/contribute/set-up-ubuntu#step-3-install-hugo" >}}), then check with `hugo version`.

### `module "github.com/imfing/hextra" not found` or an error that mentions `go`

**What it means:** Hugo needs Go to download the theme, and Go is missing.

**Fix:**

```bash
sudo apt install -y golang-go
go version
```

Then run `make serve` again.

### `make: *** No rule to make target 'serve'` or `No targets specified and no makefile found`

**What it means:** you're not in the project folder, or the `Makefile` is missing.

**Fix:**

```bash
cd ~/thrown-home-labbing
ls Makefile
```

If `ls` says `No such file or directory`, the `Makefile` is missing from your copy. Run `git status` and `git pull` to get it back.

### The browser says "This site can't be reached"

**What it means:** the Hugo server isn't running, or the address is wrong.

**Fix:** check that the terminal running `make serve` is still open and says `Press Ctrl+C to stop`. Use the full address, including `/thrown-home-labbing/` at the end: <http://localhost:1313/thrown-home-labbing/>.

## Work with Git

### `error: src refspec main does not match any`

**What it means:** you tried to push a branch that doesn't exist yet. Usually there are no commits, or the branch is called `master` instead of `main`.

**Fix:**

```bash
git status                 # are there changes waiting to be committed?
git add .
git commit -m "Describe your change"
git branch -M main         # rename the current branch to main
git push -u origin main
```

### `Bad owner or permissions on ~/.ssh/config`

**What it means:** SSH refuses to use its settings file because other users could change it. This often happens after editing the file with `sudo`.

**Fix:**

```bash
sudo chown -R $USER:$USER ~/.ssh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
```

### `Permission denied (publickey)`

**What it means:** the site you're pushing to doesn't recognize your SSH key.

**Fix:** add your public key to your account. Print it with:

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy the whole line. On GitHub, go to your profile picture, **Settings**, **SSH and GPG keys**, **New SSH key**, and paste it. Test it with `ssh -T git@github.com`.

To skip SSH entirely, clone with the `https://` address instead, as the setup page does.

### `fatal: not a git repository`

**What it means:** you're in a folder that isn't the project.

**Fix:** `cd ~/thrown-home-labbing` and try again. If you're not sure where the project is:

```bash
find ~ -maxdepth 3 -type d -name "thrown-home-labbing" 2>/dev/null
```

### A copy of the folder appears inside the project after unzipping

**What it means:** the zip file had its own top-level folder, so unzipping inside the project made a copy one level down.

**Fix:** move the files up one level and delete the extra folder. Replace `inner-folder` with its name:

```bash
cp -r inner-folder/. .
rm -rf inner-folder
git status
```

Check that `git status` shows the files you expected, and nothing named `inner-folder`.

## Checks on GitHub

### The Lint check fails with `exit code 2`

**What it means:** a command in the check failed. Exit code 2 often comes from `make` when the `Makefile` or a target is missing.

**Fix:** click **Details** next to the failed check, then click the red step to read its output. If it says `No rule to make target`, check that the `Makefile` is committed:

```bash
git ls-files Makefile
```

No output means it isn't in the repository. Add it, commit, and push.

### Vale reports a style error

**What it means:** a sentence doesn't follow the Grafana Labs style guide.

**Fix:** each error line names the file, line number, and the change to make. For example, `Use 'refer to' instead of 'see'` means exactly that. If Vale flags a correct technical word as misspelled, add the word to `.vale/styles/config/vocabularies/Thrown/accept.txt`, one word per line.

### `Rate limit exceeded` in the browser

**What it means:** too many requests came from your internet connection in a short time. Pipeline and job pages that refresh themselves are a common cause.

**Fix:** close all the tabs for that site, wait 10 to 15 minutes, and sign in before you try again.

## Still stuck?

[Open an issue](https://github.com/ThrownWolfCon/thrown-home-labbing/issues/new) with:

1. What you were trying to do.
1. The exact command you ran.
1. The full error message. Copy it as text rather than taking a screenshot, so it's searchable.
