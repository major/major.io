---
title: Very slow ssh logins on Fedora 22
author: Major Hayden
type: post
date: 2015-07-27T12:09:44+00:00
url: /2015/07/27/very-slow-ssh-logins-on-fedora-22/
dsq_thread_id:
  - 3975604560
categories:
  - Blog Posts
tags:
  - fedora
  - ssh
  - systemd

---
I've recently set up a Fedora 22 firewall/router at home (more on that later) and I noticed that remote ssh logins were extremely slow. In addition, sudo commands seemed to stall out for the same amount of time (about 25-30 seconds).

I've done all the basic troubleshooting already:

  * Switch to `UseDNS no` in `/etc/ssh/sshd_config`
  * Set `GSSAPIAuthentication no` in `/etc/ssh/sshd_config`
  * Tested DNS resolution

These lines kept cropping up in my system journal when I tried to access the server using ssh:

```
dbus[4865]: [system] Failed to activate service 'org.freedesktop.login1': timed out
sshd[7391]: pam_systemd(sshd:session): Failed to create session: Activation of org.freedesktop.login1 timed out
sshd[7388]: pam_systemd(sshd:session): Failed to create session: Activation of org.freedesktop.login1 timed out
```


The process list on the server looked fine. I could see `dbus-daemon` and `systemd-logind` processes and they were in good states. However, it looked like `dbus-daemon` had restarted at some point and `systemd-logind` had not been restarted since then. I crossed my fingers and bounced `systemd-logind`:

```
systemctl restart systemd-logind
```


Success! Logins via ssh and escalations with sudo worked instantly.
