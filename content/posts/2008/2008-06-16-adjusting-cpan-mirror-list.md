---
title: Adjusting CPAN mirror list
author: Major Hayden
date: 2008-06-16T17:00:01+00:00
url: /2008/06/16/adjusting-cpan-mirror-list/
dsq_thread_id:
  - 3642771573
tags:
  - perl

---
One of the most frustrating aspects of CPAN is connecting to mirrors via FTP. Most of the time, the mirrors are extraordinarily slow when it comes to FTP logins, and they often fail. As we all know, RHEL enjoys pulling some shenanigans (Scalar::Util - enough said) when perl receives an upgrade, and when I need CPAN to work quickly, it often does the opposite.

I was struggling to find a way to reconfigure CPAN to use HTTP mirrors rather than FTP, but I couldn't figure out where CPAN was holding this data. It wasn't in ~/.cpan and there was nothing in /etc for it. However, I found that you can reconfigure CPAN by running the following command:

```
# perl -MCPAN -e shell
CPAN: File::HomeDir loaded ok (v0.69)
cpan shell -- CPAN exploration and modules installation (v1.9205)
ReadLine support enabled
cpan[1]> o conf init
```

The configuration script will run again as if you had never configured CPAN. Best of all, if you need to stop mid-way through the reconfiguration, your original configuration is still there. If you'd rather just adjust your mirror list rather than starting over completely with the CPAN configuration, use the following:

Display your current mirrors:

```
o conf urllist
```

Delete the first mirror in your list:

```
o conf urllist shift
```

Delete the last mirror in your list:

```
o conf urllist pop
```

Add on a new mirror:

```
o conf urllist push http://cpan.mirror.facebook.com/
```

Save your mirror changes:

```
o conf urllist commit
```
