---
title: "Passwordless SSH"
linkTitle: "Passwordless SSH"
description: "Set up key-based SSH login to another machine, add a shortcut for it, and then turn off password logins without locking yourself out."
weight: 10
params:
  topic: tutorial
  area: "Security & access"
  time: "about 15 minutes"
  difficulty: "Beginner"
tags: ["Security"]
---

{{< lab-meta >}}

## Goal

Set up key-based SSH login to another machine, add a shortcut for it, and then turn off password logins without locking yourself out.

## You'll need

- A local machine (your laptop or desktop)
- A server you can already SSH into with a password, for example a VM or a Raspberry Pi running `openssh-server`

In the commands below, replace `<user>` with your account on the server and `<server>` with its hostname or IP.

## Do it

1. **Check for an existing key** on your local machine:

    ```bash
    ls -la ~/.ssh
    ```

    If you see `id_ed25519` and `id_ed25519.pub` (or `id_rsa` and `id_rsa.pub`), skip to step 3.

2. **Generate a key:**

    ```bash
    ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)"
    ```

    Press **Enter** to accept the default path. A passphrase is recommended. Pair it with `ssh-agent` so you only type it once per session.

3. **Copy the public key to the server:**

    ```bash
    ssh-copy-id <user>@<server>
    ```

    Non-standard port: `ssh-copy-id -p 2222 <user>@<server>`. Specific key: `ssh-copy-id -i ~/.ssh/id_ed25519.pub <user>@<server>`.

4. **Test it in a new terminal.** Keep your existing session open until this works.

    ```bash
    ssh <user>@<server>
    ```

5. **Add a shortcut.** Edit `~/.ssh/config` on your local machine:

    ```text
    Host lab
        HostName <server>
        User <user>
        IdentityFile ~/.ssh/id_ed25519
        IdentitiesOnly yes
    ```

    Now `ssh lab` is all you need.

6. **Turn off password login on the server** (only after step 4 works):

    ```bash
    echo "PasswordAuthentication no" | sudo tee /etc/ssh/sshd_config.d/10-no-passwords.conf
    sudo sshd -t && sudo systemctl reload ssh
    ```

## What you should see

- Step 3 ends with `Number of key(s) added: 1`.
- Step 4 logs you in without a password prompt (or with only your key's passphrase).
- After step 6, `ssh -o PubkeyAuthentication=no <user>@<server>` fails with `Permission denied (publickey)`.

{{< callout type="warning" >}}
**Don't lock yourself out**

Always test the new login in a **separate** terminal before closing your working session, and run `sshd -t` before reloading. It checks the config and stops you from reloading a broken one.
{{< /callout >}}

**Troubleshooting:** run `ssh -v lab` to see which keys are offered. On the server, `journalctl -u ssh -n 30` shows why a key was refused. The most common cause is permissions: `~/.ssh` must be `700` and `~/.ssh/authorized_keys` must be `600`.

## Cleanup

To undo on the server:

```bash
sudo rm /etc/ssh/sshd_config.d/10-no-passwords.conf
sudo systemctl reload ssh
```

Remove your key's line from `~/.ssh/authorized_keys` on the server, and the `Host lab` block from your local `~/.ssh/config`.

{{< callout type="info" >}}
On Fedora and RHEL the service is `sshd`, not `ssh`.
{{< /callout >}}

## Next steps

- Use `ssh -J` to jump through one host to reach another.
- Restrict a key to one command with `command="..."` in `authorized_keys`.
