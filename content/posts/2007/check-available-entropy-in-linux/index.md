---
aliases:
- /2007/07/01/check-available-entropy-in-linux/
author: Major Hayden
date: 2007-07-01 16:46:11
tags:
- security
title: Check available entropy in Linux
---

Sometimes servers just have the weirdest SSL problems ever. In some of these situations, the entropy has been drained. Entropy is the measure of the random numbers available from /dev/urandom, and if you run out, you can't make SSL connections. To check the status of your server's entropy, just run the following:

```text
# cat /proc/sys/kernel/random/entropy_avail
```

If it returns anything less than 100-200, you have a problem. Try installing rng-tools, or generating I/O, like large find operations. Linux normally uses keyboard and mouse input to generate entropy on systems without random number generators, and this isn't very handy for dedicated servers.