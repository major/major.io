---
title: Compare the RPM packages installed on two different servers
author: Major Hayden
type: post
date: 2009-03-10T23:31:49+00:00
url: /2009/03/10/compare-the-rpm-packages-installed-on-two-different-servers/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642805494
categories:
  - Blog Posts
tags:
  - diff
  - fedora
  - linux
  - red hat
  - rpm

---
Setting up new servers can be a pain if you're not able to clone them from a server that is known to be working. Many VPS providers, like [Slicehost][1], allow you to clone a system to a new system. Without that option, you can pull a list of RPM's without their version number for a fairly quick and basic comparison.

First, pull a list of RPM package by name only:

<pre lang="html">rpm -qa --queryformat='%{NAME}\n' | sort > server.txt</pre>

Once you've done that on both servers, just use diff to compare the two files:

<pre lang="html">diff serverold.txt servernew.txt</pre>

 [1]: http://slicehost.com/
