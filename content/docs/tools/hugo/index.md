---
title: "Hugo"
description: "Hugo turns the Markdown files in content/ into the website."
weight: 40
params:
  topic: reference
---

**Hugo** is a *static site generator*. It reads Markdown files and templates and writes out a complete website as plain HTML files. GitLab and Grafana Labs both build their documentation with Hugo.

## What it does in this project

- `make serve` runs `hugo server`, which builds the site and serves it at <http://localhost:1313/thrown-home-labbing/>. It rebuilds every time you save a file.
- The **Deploy** workflow runs `hugo` on GitHub to build the site for GitHub Pages.
- Hugo checks every internal link written with `ref`. A link to a page that doesn't exist stops the build with an error.

## Check if it's installed

```bash
hugo version
which hugo
```

**You should see:** a line starting with `hugo v0.170.1` or later, and the path `/usr/local/bin/hugo`.

{{< callout type="info" >}}
**No "extended" in the version line?**

That's expected. Recent releases don't print `extended`, even for the extended edition.
{{< /callout >}}

**More than one Hugo?** Run `which -a hugo`. If it lists more than one path, you have several copies, and the first one wins. Remove the extras, as described in [Remove](#remove).

## Install

Use the same version as the site's GitHub workflow, from Hugo's own releases.

{{< callout type="warning" >}}
**Don't use `sudo apt install hugo`**

Ubuntu's package is usually too old for the theme, which needs Hugo 0.146 or later.
{{< /callout >}}

```bash
cd /tmp
wget https://github.com/gohugoio/hugo/releases/download/v0.170.1/hugo_extended_0.170.1_linux-amd64.deb
sudo apt install -y ./hugo_extended_0.170.1_linux-amd64.deb
cd ~
hugo version
```

Hugo also needs [Go]({{< ref "/docs/tools/go" >}}) to download the theme.

## Update

1. Find the newest version on the [Hugo releases page](https://github.com/gohugoio/hugo/releases).
1. Run the [Install](#install) commands again, replacing `0.170.1` with the new version in both places. `apt` replaces the old version.
1. Update the version the website build uses, so your computer and GitHub match. In both `.github/workflows/deploy.yml` and `.github/workflows/lint.yml`, change this line:

    ```yaml
    HUGO_VERSION: 0.170.1
    ```

### Update the theme

```bash
cd ~/thrown-home-labbing
hugo mod get -u github.com/imfing/hextra
hugo mod tidy
make serve
```

Check that the site still looks right, then commit the changed `go.mod` and `go.sum`.

## Remove

```bash
sudo apt remove -y hugo
```

If `which -a hugo` still finds a copy, remove that one too:

| Where it is | How to remove it |
| --- | --- |
| `/snap/bin/hugo` | `sudo snap remove hugo` |
| `/usr/bin/hugo` (Ubuntu's package) | `sudo apt remove hugo` |
| `~/go/bin/hugo` | `rm ~/go/bin/hugo` |

To clear Hugo's download cache, including the theme:

```bash
rm -rf ~/.cache/hugo_cache
```

## Commands you'll use

| Command | What it does |
| --- | --- |
| `hugo server` | Builds the site and serves it locally with live reload |
| `hugo` | Builds the site into `public/` |
| `hugo --gc --minify` | Builds a smaller site and cleans up unused files |
| `hugo mod graph` | Lists the modules the site uses, such as the theme |
| `hugo mod get -u` | Updates the modules |
| `hugo mod clean` | Deletes this project's module cache |
| `hugo env` | Shows Hugo's version and build details |

## Files in this project

| File or folder | What it's for |
| --- | --- |
| `hugo.toml` | Site settings: title, address, menu, theme options |
| `content/` | The pages, in Markdown |
| `layouts/_shortcodes/` | This site's own shortcodes, `lab-meta` and `lab-index` |
| `public/` | The built site. Hugo makes it, and Git ignores it. |

## Key ideas

- **Front matter:** the block between `---` lines at the top of each page. It sets the title, description, and order. Refer to the [lab template]({{< ref "/docs/contribute/lab-template" >}}).
- **Page bundles:** each page is a folder with an `index.md` inside, such as `labs/linux/debug-failing-service/index.md`. Images for that page can sit in the same folder.
- **Sections:** a folder with an `_index.md` becomes a section with its own landing page, like **Labs**.
- **Shortcodes:** small templates you call from Markdown, such as `{{</* callout */>}}`.

## Official documentation

- [Hugo documentation](https://gohugo.io/documentation/)
- [Front matter](https://gohugo.io/content-management/front-matter/)
- [Page bundles](https://gohugo.io/content-management/page-bundles/)
- [Shortcodes](https://gohugo.io/content-management/shortcodes/)
- [Hextra theme documentation](https://imfing.github.io/hextra/docs/)

## Related pages

- [Set up your computer: Step 3]({{< ref "/docs/contribute/set-up-ubuntu#step-3-install-hugo" >}})
- [Troubleshooting: Run the site]({{< ref "/docs/contribute/troubleshooting#run-the-site" >}})
