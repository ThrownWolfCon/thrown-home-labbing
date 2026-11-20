# Thrown Home Labbing

Hands-on homelab projects to keep Linux, networking, storage, container, Git, and observability skills sharp. Each lab is short, safe to run on your own machine, and ends with cleanup.

**Site:** <https://thrownwolfcon.github.io/thrown-home-labbing/>

## How it's built

| Piece | Tool |
| --- | --- |
| Static site generator | [Hugo](https://gohugo.io/) (extended), with the [Hextra](https://imfing.github.io/hextra/) theme as a Hugo module |
| Content | Markdown page bundles in `content/docs/`, with front matter |
| Prose linting | [Vale](https://vale.sh/) with the [Grafana Labs Writers' Toolkit](https://grafana.com/docs/writers-toolkit/) style |
| Markdown linting | [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2) |
| CI/CD | GitHub Actions: `lint.yml` on pull requests, `deploy.yml` to GitHub Pages on `main` |

## Preview locally

You need [Hugo extended](https://gohugo.io/installation/linux/) 0.146 or later, and Go 1.22 or later for Hugo modules.

```bash
sudo apt install golang-go      # Go, for Hugo modules
make serve                      # http://localhost:1313/thrown-home-labbing/
```

## Lint locally

You need [Vale](https://vale.sh/docs/install) and Node.js (for `npx`).

```bash
make vale-sync    # first time only: fetches the Grafana style
make lint
```

## Add a lab

1. Copy the template from `content/docs/contribute/lab-template/index.md` into a new page bundle, for example `content/docs/labs/linux/my-lab/index.md`.
1. Fill in the front matter and every section, including **Cleanup**.
1. Run `make lint` and `make serve`.
1. Open a pull request.

The lab index and area pages list labs automatically from front matter, so there's no table to update.

## Repository layout

```text
.
├── content/
│   ├── _index.md                 # home page
│   └── docs/
│       ├── getting-started/
│       ├── labs/<area>/<lab>/index.md
│       ├── skills-map/
│       └── contribute/
├── layouts/_shortcodes/          # custom shortcodes: lab-meta, lab-index
├── .github/workflows/            # deploy.yml, lint.yml
├── .vale.ini                     # Vale config
├── .vale/styles/config/vocabularies/Thrown/accept.txt   # project vocabulary
├── .markdownlint-cli2.yaml
├── hugo.toml
└── Makefile
```

## Credits

- Theme: [Hextra](https://github.com/imfing/hextra) (MIT).
- Vale style: [Grafana Labs Writers' Toolkit](https://github.com/grafana/writers-toolkit) (Apache 2.0), fetched at lint time and not redistributed here.
