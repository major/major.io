---
title: 'New Fedora and EPEL package: httpry'
author: Major Hayden
type: post
date: 2012-03-14T14:00:29+00:00
url: /2012/03/14/new-fedora-and-epel-package-httpry/
dsq_thread_id:
  - 3642806930
categories:
  - Blog Posts
tags:
  - centos
  - command line
  - development
  - fedora
  - linux
  - red hat
  - rpm
  - scientific linux

---
A fellow Racker showed me [httpry][1] about five years ago and I've had in my toolbox as a handy way to watch HTTP traffic. I'd used some crazy tcpdump arguments and some bash one-liners to pull out the information I needed but I never could get the live look that I really wanted.

Here's an example of what httpry's output looks like on a busy site like icanhazip.com:

```
 GET	icanhazip.com	/	HTTP/1.1	-	-
2012-03-13 23:29:39 192.x.x.x	186.x.x.x &lt; -	-	-	HTTP/1.1	200	OK
2012-03-13 23:29:39 187.x.x.x	192.x.x.x > GET	icanhazip.com	/	HTTP/1.0	-	-
2012-03-13 23:29:39 192.x.x.x	187.x.x.x &lt; -	-	-	HTTP/1.0	200	OK
2012-03-13 23:29:39 188.x.x.x	192.x.x.x > GET	icanhazip.com	/	HTTP/1.1	-	-
2012-03-13 23:29:39 192.x.x.x	188.x.x.x &lt; -	-	-	HTTP/1.1	200	OK
2012-03-13 23:29:39 189.x.x.x	192.x.x.x > GET	icanhazip.com	/	HTTP/1.1	-	-
2012-03-13 23:29:39 192.x.x.x	189.x.x.x &lt; -	-	-	HTTP/1.1	200	OK
```


You can watch the requests come in and the responses go out in real time. It even allows for BPF-style packet filters which allow you to narrow down the source and/or destination IP addresses and ports you want to watch. You can run it as a foreground process or as a daemon depending on your needs.

It's now available as a [RPM package][2] for Fedora 15, 16, 17 (and rawhide) as well as EPEL 6 (for RHEL/CentOS/SL 6).

 [1]: http://dumpsterventures.com/jason/httpry/
 [2]: https://admin.fedoraproject.org/updates/httpry
