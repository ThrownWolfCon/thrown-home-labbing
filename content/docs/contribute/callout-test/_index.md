---
title: Callout Test
weight: 99
---

## Shortcode callouts: every type

{{< callout >}}
  **Default:** no type set. This is the fallback style.
{{< /callout >}}

{{< callout type="info" >}}
  **Info:** extra context the reader might want.
{{< /callout >}}

{{< callout type="warning" >}}
  **Warning:** back up your config before upgrading.
{{< /callout >}}

{{< callout type="error" >}}
  **Error:** this will delete data. There is no undo.
{{< /callout >}}

{{< callout type="important" >}}
  **Important:** you must restart the service after this step.
{{< /callout >}}

## Custom icon and emoji

{{< callout type="info" icon="sparkles" >}}
  Custom icon instead of the default one for this type.
{{< /callout >}}

{{< callout emoji="💡" >}}
  Emoji instead of an icon. Handy for tips.
{{< /callout >}}

{{< callout type="warning" emoji="🐺" >}}
  Thrown Wolf says: read the whole page before running anything.
{{< /callout >}}

## Markdown inside a callout

{{< callout type="info" >}}
  Callouts can hold **bold**, `inline code`, [links](/docs/), and lists:

  - First thing
  - Second thing
{{< /callout >}}

## GitHub-style alerts (render hook, not a shortcode)

> [!NOTE]
> Useful information the reader should notice.

> [!TIP]
> A helpful suggestion for doing things better.

> [!IMPORTANT]
> Key information the reader needs to succeed.

> [!WARNING]
> Urgent info that needs immediate attention.

> [!CAUTION]
> Advises about risks or negative outcomes.

## Plain blockquote (for comparison)

> Just a normal quote. No alert styling.