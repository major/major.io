---
title: Disable SSH timeouts
author: Major Hayden
type: post
date: 2007-04-12T16:15:02+00:00
url: /2007/04/12/disable-ssh-timeouts/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642766550
categories:
  - Blog Posts
tags:
  - command line
  - security

---
To pretty much completely disable SSH timeouts, simply adjust the following directives in /etc/ssh/sshd_config:

```
TCPKeepAlive yes
ClientAliveInterval 30
ClientAliveCountMax 99999
```

**EDIT:** Once that's changed, be sure to restart your ssh daemon.

<span style="color: #D42020; font-weight: bold;">SECURITY WARNING:</span> If you remove users from your system, but they're still connected via ssh, their connection may remain open indefinitely. Be sure to check all active ssh sessions after adjusting a user's access.
