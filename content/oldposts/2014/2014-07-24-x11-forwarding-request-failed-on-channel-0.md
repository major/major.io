---
title: X11 forwarding request failed on channel 0
author: Major Hayden
date: 2014-07-24T19:24:32+00:00
url: /2014/07/24/x11-forwarding-request-failed-on-channel-0/
dsq_thread_id:
  - 3642807637
tags:
  - debian
  - ipv6
  - ssh
  - x11

---
Forwarding X over ssh is normally fairly straightforward when you have the correct packages installed. I have [another post][1] about the errors that appear when you're missing the _xorg-x11-xauth_ (CentOS, Fedora, RHEL) or _xauth_ (Debian, Ubuntu) packages.

Today's error was a bit different. Each time I accessed a particular Debian server via ssh with X forwarding requested, I saw this:

```
$ ssh -YC myserver.example.com
X11 forwarding request failed on channel 0
```


The _xauth_ package was installed and I found a _.Xauthority_ file in root's home directory. Removing the _.Xauthority_ file and reconnecting via ssh didn't help. After some searching, I stumbled upon a [GitHub gist][2] that had some suggestions for fixes.

On this particular server, IPv6 was disabled. That caused the error. The quickest fix was to restrict sshd to IPv4 only by adding this line to _/etc/ssh/sshd_config_:

```
AddressFamily inet
```


I restarted the ssh daemon and I was able to forward X applications over ssh once again.

 [1]: /2012/07/14/x-forwarding-over-ssh-woes-display-is-not-set/
 [2]: https://gist.github.com/adrianratnapala/1324845
