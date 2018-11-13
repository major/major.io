---
title: Install Debian packages without starting daemons
author: Major Hayden
type: post
date: 2014-06-26T20:39:44+00:00
url: /2014/06/26/install-debian-packages-without-starting-daemons/
dsq_thread_id:
  - 3642807616
categories:
  - Blog Posts
tags:
  - centos
  - debian
  - fedora
  - red hat
  - yum

---
My work at Rackspace has involved working with a bunch of Debian chroots lately. One problem I had was that daemons tried to start in the chroot as soon as I installed them. That created errors and made my ansible output look terrible.

If you'd like to prevent daemons from starting after installing a package, just toss a few lines into _/usr/sbin/policy-rc.d_:

```
 /usr/sbin/policy-rc.d &lt; &lt; EOF
#!/bin/sh
echo "All runlevel operations denied by policy" >&2
exit 101
EOF
```


Now, install any packages that you need and the daemons will remain stopped until you start them (or reboot the server). Be sure to remove the policy file you added once you're done installing your packages.

* * *

_This seems like a good opportunity to get on a soapbox about automatically starting daemons. ;)

_

I still have a very difficult time understanding why Debian-based distributions start daemons as soon as the package is installed. Having an option to enable this might be useful for some situations, but this **shouldn't be the default**.

You end up with situations like the one in this [puppet bug report][1]. The daemon shouldn't start until you're ready to configure it and use it. However, the logic is that the daemon is so horribly un-configured that it shouldn't hurt anything if starts immediately. So why start the daemon at all?

When I run the command _apt-get install_ or _yum install_, I expect that packages will be installed to disk and nothing more. Even the [definition of the English word "install"][2] talks about "preparing" something for use, not actually using it:

> To connect, set up or prepare something for use

**If I install an electrical switch at home, I don't install it in the ON position with my circuit breaker in the ON position.** I install it with everything off, verify my work, ensure that it fits in place, and then I apply power. The installation and actual **use** of the new switch are two completely separate activities with additional work required in between.

I strongly urge the Debian community to consider switching to a mechanism where daemons don't start until the users configure them properly and are ready to use them. This makes configuration management much easier, improves security, and provides consistency with almost every other Linux distribution.

 [1]: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=723080
 [2]: https://en.wiktionary.org/wiki/install
