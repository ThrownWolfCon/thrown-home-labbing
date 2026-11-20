---
title: "Edit config files with sed"
linkTitle: "sed config edits"
description: "Change values in config files from the command line, safely, and know the difference between editing part of a line and replacing the whole line."
weight: 60
params:
  topic: tutorial
  area: "Linux"
  time: "about 15 minutes"
  difficulty: "Beginner"
tags: ["Linux"]
---

{{< lab-meta >}}

## Goal

Change values in config files from the command line, safely, and know the difference between editing part of a line and replacing the whole line.

## You'll need

- Any Linux machine. No `sudo` needed.

## Setup

```bash
mkdir -p ~/sed-lab && cd ~/sed-lab
cat > app.conf <<'EOF'
foo bar foo baz foo
IMPORTANT_VARIABLE=TRUE
IMPORTANT_VARIABLE=TRUE FOR REALSIES!
LOG_LEVEL=info
EOF
```

## Do it

1. **Substitute the first match on each line.** Without `-i`, sed only prints the result:

    ```bash
    sed 's/foo/bar/' app.conf
    ```

2. **Substitute every match** with `g`:

    ```bash
    sed 's/foo/bar/g' app.conf
    ```

3. **Change part of a matching line.** Only touch lines containing `IMPORTANT_VARIABLE=`:

    ```bash
    sed '/IMPORTANT_VARIABLE=/s/=TRUE/=FALSE/' app.conf
    ```

4. **Replace the whole matching line** ("clobber") with `c\`:

    ```bash
    sed '/IMPORTANT_VARIABLE=/c\IMPORTANT_VARIABLE=FALSE' app.conf
    ```

5. **Edit in place, with a backup:**

    ```bash
    sed -i.bak 's/^LOG_LEVEL=.*/LOG_LEVEL=debug/' app.conf
    diff app.conf.bak app.conf
    ```

## What you should see

Steps 3 and 4 look similar but differ on the last `IMPORTANT_VARIABLE` line:

| Command | Result |
| --- | --- |
| `s/=TRUE/=FALSE/` (substitute) | `IMPORTANT_VARIABLE=FALSE FOR REALSIES!` |
| `c\` (change line) | `IMPORTANT_VARIABLE=FALSE` |

Substitute keeps whatever else is on the line; change throws it away.

{{< callout type="default" >}}
**Preview, then commit**

Run the command without `-i` first, check the output, then add `-i.bak`. Keep the backup until you've confirmed the service still starts.
{{< /callout >}}

## Cleanup

```bash
rm -rf ~/sed-lab
```

## Next steps

- Delete lines: `sed '/^LOG_LEVEL/d' app.conf` removes the log level line.
- Only edit a line range: `sed '2,3s/foo/qux/g' app.conf`.
- The [GNU sed manual](https://www.gnu.org/software/sed/manual/sed.html) covers everything else.
