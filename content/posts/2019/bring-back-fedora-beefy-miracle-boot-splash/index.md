---
aliases:
- /2019/12/16/bring-back-fedora-beefy-miracle-boot-splash/
author: Major Hayden
date: '2019-12-16'
summary: >
  Fedora 17's code name was Beefy Miracle and it had a great mascot.
  You can see it at boot time with a few quick changes.
tags:
- fedora
- linux
title: Bring Back Fedora's Beefy Miracle boot splash
---

Way back in 2012 when Fedora releases had names, there was one release that
many of us in the Fedora community will never forget. Fedora 17's [code name]
was "Beefy Miracle" and it caused plenty of giggles and lots of consternation
(especially in vegetarian and vegan circles).

No matter how you feel about the code name, the mascot was really good:

![2019-12-16-major-and-beefy-miracle.jpg](2019-12-16-major-and-beefy-miracle.jpg "Major and the beefy miracle in 2012")

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

![2019-12-16-hot-dog-boot-splash.jpg](2019-12-16-hot-dog-boot-splash.jpg "Hot dog boot splash")

[code name]: https://fedoraproject.org/wiki/History_of_Fedora_release_names#Fedora_17_.28Beefy_Miracle.29