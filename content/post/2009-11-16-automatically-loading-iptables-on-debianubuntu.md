---
title: Automatically loading iptables rules on Debian/Ubuntu
author: Major Hayden
type: post
date: 2009-11-17T04:39:52+00:00
url: /2009/11/16/automatically-loading-iptables-on-debianubuntu/
dsq_thread_id:
  - 3642805844
categories:
  - Blog Posts
tags:
  - debian
  - iptables
  - networking
  - scripts
  - security
  - ubuntu

---
If you want your iptables rules automatically loaded every time your networking comes up on your Debian or Ubuntu server, you can follow these easy steps.

First, get your iptables rules set up the way you like them. Once you've verified that everything works, save the rules:

```


Next, open up `/etc/network/if-up.d/iptables` in your favorite text editor and add the following:

```
#!/bin/sh
iptables-restore &lt; /etc/firewall.conf</pre>

Once you save it, make it executable:

```


Now, the rules will be restored each time your networking scripts start (or restart). If you need to save changes to your rules in the future, you can manually edit `/etc/firewall.conf` or you can adjust your rules live and run:

```


_Thanks to [Ant][1] for this handy tip._

 [1]: http://twitter.com/ajmesserli
