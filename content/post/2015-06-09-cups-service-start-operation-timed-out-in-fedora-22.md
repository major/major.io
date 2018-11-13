---
title: cups.service start operation timed out in Fedora 22
author: Major Hayden
type: post
date: 2015-06-09T14:35:48+00:00
url: /2015/06/09/cups-service-start-operation-timed-out-in-fedora-22/
dsq_thread_id:
  - 3834462486
categories:
  - Blog Posts
tags:
  - dns
  - fedora
  - networking
  - printing

---
Applications on my Fedora 22 system kept stalling when I attempted to print. My system journal was full of these log messages:

```
systemd[1]: cups.service start operation timed out. Terminating.
systemd[1]: Failed to start CUPS Scheduler.
systemd[1]: Unit cups.service entered failed state.
systemd[1]: cups.service failed.
audit[1]: &lt;audit-1130> pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=cups comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=failed'
```


If I tried to run `systemctl start cups`, the command would hang for quite a while and then fail. I broke out [strace][1] and tried to figure out what was going wrong.

The strace output showed that cups was talking to my local DNS servers and was asking constantly for the IP address of my laptop's hostname.

[<img src="/wp-content/uploads/2015/06/iWKad22.jpg" alt="facepalm - cups fails without an entry in /etc/hosts" width="480" height="270" class="aligncenter size-full wp-image-5635" srcset="/wp-content/uploads/2015/06/iWKad22.jpg 480w, /wp-content/uploads/2015/06/iWKad22-300x169.jpg 300w" sizes="(max-width: 480px) 100vw, 480px" />][2]

Oh, I felt pretty stupid at this point.

I added my laptop's hostname onto the line starting with `127.0.0.1` in my `/etc/hosts` and tried to start cups once more. It started up in less than a second and is now working well.

 [1]: http://linux.die.net/man/1/strace
 [2]: /wp-content/uploads/2015/06/iWKad22.jpg
