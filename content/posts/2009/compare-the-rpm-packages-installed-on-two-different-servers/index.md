---
aktt_notify_twitter:
- false
aliases:
- /2009/03/10/compare-the-rpm-packages-installed-on-two-different-servers/
author: Major Hayden
date: 2009-03-10 23:31:49
tags:
- diff
- fedora
- linux
- red hat
- rpm
title: Compare the RPM packages installed on two different servers
---

Setting up new servers can be a pain if you're not able to clone them from a server that is known to be working. Many VPS providers, like [Slicehost][1], allow you to clone a system to a new system. Without that option, you can pull a list of RPM's without their version number for a fairly quick and basic comparison.

First, pull a list of RPM package by name only:

<pre lang="html">rpm -qa --queryformat='%{NAME}\n' | sort | uniq > server.txt</pre>

Once you've done that on both servers, just use diff to compare the two files:

<pre lang="html">diff serverold.txt servernew.txt</pre>

 [1]: http://slicehost.com/