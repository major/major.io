---
aliases:
- /2012/02/01/openstack-bleeding-edge-python-packages-are-now-available/
author: Major Hayden
date: 2012-02-01 15:05:16
tags:
- apache
- command line
- git
- ipv6
- openstack
- python
- web
title: OpenStack bleeding-edge Python packages are now available
---

I sometimes enjoy living on the edge occasionally and that sometimes means I keep up with OpenStack changes commit by commit. If you're in the same boat as I am, you may save some time by using my repository of bleeding-edge Python packages from the OpenStack projects:

  * [pypi.mhtx.net][1]

Python packages are updated moments after the commit is merged into the repositories under [OpenStack's github account][2].

Although the packages will contain the latest code available, rest assured that the code has passed an initial code review (by humans), unit tests, and varying levels of functional or integrated testing. There may still be a bug or two cropping up after that, so be aware of that as you utilize these packages.

The package versions utilize a standard format:

<pre lang="html">[package]-[version]-[git commit count]-[short commit hash]</pre>

If you need to check the git log up to that particular commit, just run `git log`:

<pre lang="html">git log [short commit hash]</pre>

Instructions for configuring `pip` or `easy_install` are provided [within the repository][1].

In addition, the repository is accessible via IPv4 and IPv6.

 [1]: http://pypi.mhtx.net/
 [2]: http://github.com/openstack