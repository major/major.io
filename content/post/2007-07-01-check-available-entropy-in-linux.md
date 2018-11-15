---
title: Check available entropy in Linux
author: Major Hayden
type: post
date: 2007-07-01T16:46:11+00:00
url: /2007/07/01/check-available-entropy-in-linux/
dsq_thread_id:
  - 3642768156
tags:
  - security

---
Sometimes servers just have the weirdest SSL problems ever. In some of these situations, the entropy has been drained. Entropy is the measure of the random numbers available from /dev/urandom, and if you run out, you can't make SSL connections. To check the status of your server's entropy, just run the following:

```
# cat /proc/sys/kernel/random/entropy_avail
```

If it returns anything less than 100-200, you have a problem. Try installing rng-tools, or generating I/O, like large find operations. Linux normally uses keyboard and mouse input to generate entropy on systems without random number generators, and this isn't very handy for dedicated servers.
