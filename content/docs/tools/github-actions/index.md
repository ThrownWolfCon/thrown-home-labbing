---
title: "GitHub Actions"
description: "GitHub Actions runs the checks and publishes the site, on computers that GitHub provides."
weight: 70
params:
  topic: reference
---

**GitHub Actions** runs automated tasks on computers that GitHub provides whenever something happens in the repository, such as a push or a pull request. This is called *CI/CD*: continuous integration (checking every change) and continuous deployment (publishing automatically).

There's nothing to install. It runs on GitHub.

## What it does in this project

| Workflow | File | When it runs | What it does |
| --- | --- | --- | --- |
| **Lint** | `.github/workflows/lint.yml` | Every push and pull request | Runs Vale and markdownlint, and checks that Hugo can build the site without warnings |
| **Deploy** | `.github/workflows/deploy.yml` | Every push to `main` | Builds the site with Hugo and publishes it to GitHub Pages |

## Check that it's working

1. Open the repository on GitHub and click the **Actions** tab.
1. Each row is one *run*. A green check means it passed, a red X means it failed, and a yellow circle means it's still running.
1. Click a run, then a job, then a step to see its full output.

{{< callout type="warning" >}}
**Close the tab when you're done**

A run's page keeps checking for updates while it's open. Several open at once can trigger a rate limit on some sites. Refer to [Troubleshooting]({{< ref "/docs/contribute/troubleshooting#rate-limit-exceeded-in-the-browser" >}}).
{{< /callout >}}

## Run a workflow by hand

1. Click the **Actions** tab.
1. In the left sidebar, click the workflow, for example **Deploy**.
1. Click **Run workflow**, keep the branch as `main`, and click the green **Run workflow** button.

## Turn GitHub Pages on

The **Deploy** workflow only works after Pages is set to use it. You do this once per repository:

1. In the repository, click **Settings**, then **Pages** in the left sidebar.
1. Under **Build and deployment**, set **Source** to **GitHub Actions**.

## Keep it up to date

The workflows use *actions*, reusable steps written by others, such as `actions/checkout@v7`. The number after `@` is the version. When GitHub warns that an action is out of date, for example about an old Node.js version, update that number to the action's newest release.

The tool versions are at the top of each workflow file:

```yaml
env:
  HUGO_VERSION: 0.170.1
  VALE_VERSION: 3.28.1
```

Keep these the same as the versions on your computer. Refer to the [Hugo]({{< ref "/docs/tools/hugo#update" >}}) and [Vale]({{< ref "/docs/tools/vale#update" >}}) pages.

## Optional: watch runs from the terminal

The GitHub CLI, `gh`, can follow a run without a browser tab:

```bash
sudo apt install -y gh
gh auth login
cd ~/thrown-home-labbing
gh run list --limit 5
gh run watch
```

## Official documentation

- [GitHub Actions documentation](https://docs.github.com/en/actions)
- [GitHub Pages documentation](https://docs.github.com/en/pages)
- [GitHub CLI manual](https://cli.github.com/manual/)

## Related pages

- [Make a change: Step 7]({{< ref "/docs/contribute/make-a-change#step-7-open-a-pull-request" >}})
- [Troubleshooting: Checks on GitHub]({{< ref "/docs/contribute/troubleshooting#checks-on-github" >}})
