---
aliases:
- /2014/05/20/switching-to-systemd-on-debian-jessie/
author: Major Hayden
date: 2014-05-20 13:47:33
tags:
- command line
- debian
- fedora
- linux
- sysadmin
- systemd
title: Switching to systemd on Debian jessie
---

[<img src="/wp-content/uploads/2014/05/Debian-icon.png" alt="Debian-icon" width="256" height="256" class="alignright size-full wp-image-4933" srcset="/wp-content/uploads/2014/05/Debian-icon.png 256w, /wp-content/uploads/2014/05/Debian-icon-150x150.png 150w" sizes="(max-width: 256px) 100vw, 256px" />][1]It seems like everyone is embracing systemd these days. It's been in Fedora since 2011 and it's already in the RHEL 7 release candidate. Arch Linux and Gentoo have it as well. Debian got on board with the jessie release (which is currently in testing).

Switching from old SysVinit to systemd in Debian jessie is quite simple. For the extremely cautious system administrators, you can [follow Debian's guide and test systemd][2] before you make the full cutover.

However, I've had great results with making the jump in one pass:

```
apt-get update
apt-get install systemd systemd-sysv
reboot
```


After you reboot, you might notice `/sbin/init` still hanging out in your process list:

```
# ps aufx | grep init
root         1  0.0  0.1  45808  3820 ?        Ss   08:16   0:00 /sbin/init
```


That's actually a symlink to systemd:

```
# ls -al /sbin/init
lrwxrwxrwx 1 root root 20 Mar 19 13:15 /sbin/init -> /lib/systemd/systemd
```


You also have journald for quick access to logs:

```
# journalctl -u cron
-- Logs begin at Tue 2014-05-20 08:16:21 CDT, end at Tue 2014-05-20 08:31:20 CDT. --
May 20 08:16:24 jessie-auditd-2 /usr/sbin/cron[837]: (CRON) INFO (pidfile fd = 3)
May 20 08:16:24 jessie-auditd-2 cron[774]: Starting periodic command scheduler: cron.
May 20 08:16:24 jessie-auditd-2 systemd[1]: Started LSB: Regular background program processing daemon.
May 20 08:16:24 jessie-auditd-2 /usr/sbin/cron[842]: (CRON) STARTUP (fork ok)
May 20 08:16:24 jessie-auditd-2 /usr/sbin/cron[842]: (CRON) INFO (Running @reboot jobs)
May 20 08:17:01 jessie-auditd-2 CRON[990]: pam_unix(cron:session): session opened for user root by (uid=0)
May 20 08:17:01 jessie-auditd-2 /USR/SBIN/CRON[991]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
```


 [1]: /wp-content/uploads/2014/05/Debian-icon.png
 [2]: https://wiki.debian.org/systemd