---
aliases:
- /2014/05/17/text-missing-in-chrome-on-linux/
author: Major Hayden
date: 2014-05-18 04:33:14
dsq_thread_id:
- 3642807526
tags:
- fedora
- red hat
- selinux
title: Text missing in chrome on Linux
---

I'm in the process of trying Fedora 20 on my retina MacBook and I ran into a peculiar issue with Chrome. Some sites would load up normally and I could read everything on the page. Other sites would load up and only some of the text would be displayed. Images were totally unaffected.

It wasn't this way on the initial installation of Fedora but it cropped up somewhere along the way as I installed software. Changing the configuration within Chrome wasn't an option - I couldn't even see any text on the configuration pages!

The only commonality I could find is that all pages that specified their own web fonts (like the pages on this site) loaded up perfectly. Everything was visible. However, on sites that tend to use whatever font is available in the browser (sites that specify a font family), the text was missing. A good example was [The Aviation Herald][1].

I remembered installing some Microsoft core fonts via [Fedy][2] and I added in some patched powerline fonts to work with tmux. A quick check of the SELinux troubleshooter alerted me to the problem: the new fonts had the wrong SELinux labels applied and Chrome wasn't allowed to access them.

I decided to relabel the whole filesystem:

```
restorecon -Rv /
```

The restorecon output was line after line of fonts that I had installed earlier in the evening. Once it finished running, I started Chrome and it was working just as I had expected.

 [1]: http://avherald.com/
 [2]: https://satya164.github.io/fedy/