---
title: "Go"
description: "Go is a programming language. Hugo uses it to download the site's theme."
weight: 30
params:
  topic: reference
---

**Go** is a programming language. You don't write any Go for this site. Hugo needs it installed because the site's theme, [Hextra](https://imfing.github.io/hextra/), is a *Hugo module*, and Hugo uses Go's tools to download modules.

## What it does in this project

- The first time you run `make serve` or `hugo`, Hugo uses Go to download the Hextra theme.
- `go.mod` lists the theme and its version. `go.sum` holds checksums that confirm the download wasn't tampered with.

## Check if it's installed

```bash
go version
which go
```

**You should see:** a version such as `go version go1.26.0 linux/amd64`, and a path such as `/usr/bin/go`. Go 1.22 or later works.

## Install

```bash
sudo apt update
sudo apt install -y golang-go
go version
```

## Update

```bash
sudo apt update
sudo apt install --only-upgrade -y golang-go
```

## Remove

Clear Go's download cache first, while Go is still installed:

```bash
go clean -modcache
```

Then remove Go:

```bash
sudo apt remove -y golang-go
sudo apt autoremove -y
```

After you remove Go, `hugo server` fails the next time it needs to download the theme.

## Files in this project

| File | What it's for |
| --- | --- |
| `go.mod` | Names the project and the theme version it uses |
| `go.sum` | Checksums for the theme download |

Both files are managed by Hugo. To update the theme, use `hugo mod get -u`, described on the [Hugo page]({{< ref "/docs/tools/hugo#update-the-theme" >}}), rather than editing them by hand.

## Official documentation

- [Go documentation](https://go.dev/doc/)
- [Hugo modules](https://gohugo.io/hugo-modules/), which explains why Hugo needs Go

## Related pages

- [Hugo]({{< ref "/docs/tools/hugo" >}})
