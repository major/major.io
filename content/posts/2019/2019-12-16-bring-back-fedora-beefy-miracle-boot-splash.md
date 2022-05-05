---
author: Major Hayden
categories:
  - Blog Posts
date: '2019-12-16'
summary: >
  Fedora 17's code name was Beefy Miracle and it had a great mascot. You can see it
  at boot time with a few quick changes.
images:
  - images/2019-12-16-beefy-miracle.png
# Not sure how it happened, but the slug ended up with a .md on the end. 🤷🏻‍♂️
aliases:
  - bring-back-fedora-beefy-miracle-boot-splash.md
slug: bring-back-fedora-beefy-miracle-boot-splash
tags:
  - fedora
  - linux
title: Bring Back Fedora's Beefy Miracle boot splash
type: post
---

{{< figure src="/images/2019-12-16-beefy-miracle.png" alt="Beefy miracle" position="center" >}}

Way back in 2012 when Fedora releases had names, there was one release that
many of us in the Fedora community will never forget. Fedora 17's [code name]
was "Beefy Miracle" and it caused plenty of giggles and lots of consternation
(especially in vegetarian and vegan circles).

No matter how you feel about the code name, the mascot was really good:

{{< figure src="/images/2019-12-16-major-and-beefy-miracle.jpg" caption="Major and the beefy miracle in 2012" alt="Major and the beefy miracle in 2012" position="center" >}}

## The mustard

I was told several times that "the mustard indicates progress." That didn't
make a lot of sense to me until I saw the Plymouth boot splash. During the
boot-up, the mustard moves from bottom to top to indicate how much of the boot
process has completed.

You can try out the hot dog boot splash yourself with a few quick commands on
Fedora.

First off, install the `hot-dog` plymouth theme:

```text
sudo dnf install plymouth-theme-hot-dog
```

Set the theme as the default and rebuild the initrd to ensure that the boot
screen is updated after you reboot:

```text
sudo plymouth-set-default-theme --rebuild-initrd hot-dog
```

This step takes a few moments to finish since it causes `dracut` to rebuild
the entire initrd with the new plymouth theme. Once it finishes, reboot your computer and you should get something like this:

{{< figure src="/images/2019-12-16-hot-dog-boot-splash.jpg" caption="Hot dog boot splash" alt="Hot dog boot splash" position="center" >}}

[code name]: https://fedoraproject.org/wiki/History_of_Fedora_release_names#Fedora_17_.28Beefy_Miracle.29
