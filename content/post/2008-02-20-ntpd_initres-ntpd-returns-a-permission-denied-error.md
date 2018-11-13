---
title: 'ntpd_initres: ntpd returns a permission denied error'
author: Major Hayden
type: post
date: 2008-02-20T18:30:02+00:00
url: /2008/02/20/ntpd_initres-ntpd-returns-a-permission-denied-error/
dsq_thread_id:
  - 3645134438
tags:
  - command line
  - ntp

---
I recently came across a server that was throwing this error into its message log:

`ntpd_initres[2619]: ntpd returns a permission denied error!`

It would only appear about every five minutes on the server, and restarting ntpd didn't correct the issue. I stopped ntpd entirely, but the error still appeared a few minutes later.

After examining the running processes, I found that there was a lonely ntpd process that was running using a non-standard method. I killed that process, started the default instance of ntpd using the init scripts, and the issue went away.

It turns out that ntpd daemon that was started manually was unable to access some of the required paths and sockets that is necessary for ntpd to run properly. These configuration items are set up in the init scripts, but they're not included when ntpd is running manually.

_This was tested on Red Hat Enterprise Linux 4._
