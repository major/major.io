---
title: Receive e-mail reports for SELinux AVC denials
author: Major Hayden
type: post
date: 2011-09-16T04:17:04+00:00
url: /2011/09/15/receive-e-mail-reports-for-selinux-avc-denials/
dsq_thread_id:
  - 3642806700
categories:
  - Blog Posts
tags:
  - centos
  - command line
  - email
  - fedora
  - messagebus
  - red hat
  - security
  - selinux
  - server
  - ssh
  - sysadmin
  - systemd
  - yum

---
SELinux isn't a technology that's easy to tackle for newcomers. However, there's been a lot of work to smooth out the rough edges while still keeping a tight grip on what applications and users are allowed to do on a Linux system. One of the biggest efforts has been around [setroubleshoot][1].

The purpose behind setroubleshoot is to let users know when access has been denied, help them resolve it if necessary, and to reduce overall frustration while working through tight security restrictions in the default SELinux policies. The GUI frontend for setroubleshoot is great for users who run Linux desktops or those who run servers with a display attached. Don't worry, you can configure setroubleshoot on remote servers to send alerts elsewhere when a GUI alert isn't an option.

Install a few packages to get started:

```


Open `/etc/setroubleshoot/setroubleshoot.conf` in your favorite text editor and adjust the `[email]` section to fit your server:

```
recipients_filepath = /var/lib/setroubleshoot/email_alert_recipients
smtp_port = 25
smtp_host = localhost
from_address = selinux@myserver.com
subject = [MyServer] SELinux AVC Alert
```


You could probably see it coming, but you need to put the e-mail addresses for your recipients into `/var/lib/setroubleshoot/email_alert_recipients`:

```


You'll notice that setroubleshoot doesn't have an init script and it doesn't exist in systemd in Fedora 15. It runs through the [dbus-daemon][2] and a quick bounce of the messagebus via its init script brings in the necessary components to run setroubleshoot:

```


A really easy (and safe) test is to ask sshd to bind to a non-standard port. Simply define an additional port on in your `/etc/ssh/sshd_config` like this:

```
Port 22
Port 222
```


When you restart sshd, it will bind to port 22 with success, but it won't be allowed to bind to port 222 (since that's blocked by SELinux as a non-standard port for the `ssh_port_t` port type). **DON'T WORRY!** Your sshd server will still be listening on port 22. If you wait a moment, you'll get an e-mail (perhaps two) that not only notify you of the denial, but they make suggestions for how to fix it:

```
SELinux is preventing /usr/sbin/sshd from name_bind access on the tcp_socket port 222.

*****  Plugin bind_ports (99.5 confidence) suggests  *************************

If you want to allow /usr/sbin/sshd to bind to network port 222
Then you need to modify the port type.
Do
# semanage port -a -t PORT_TYPE -p tcp 222
   where PORT_TYPE is one of the following: ...
```


For this particular example, the quick fix would be to run:

```
semanage port -a -t ssh_port_t -p tcp 222
```


* * *

_

Much of this post's information was gathered from the detailed documentation on [Fedora's setroubleshoot User's FAQ][3] as well as [Dan Walsh's setroubleshoot blog post][4].

_ </p>

 [1]: https://fedorahosted.org/setroubleshoot/wiki/SETroubleShoot%20Overview
 [2]: http://en.wikipedia.org/wiki/D-Bus
 [3]: http://fedoraproject.org/wiki/Docs/Drafts/SELinux/SETroubleShoot/UserFAQ
 [4]: http://danwalsh.livejournal.com/20931.html
