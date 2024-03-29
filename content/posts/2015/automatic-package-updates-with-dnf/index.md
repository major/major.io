---
aliases:
- /2015/05/11/automatic-package-updates-with-dnf/
author: Major Hayden
date: 2015-05-12 01:22:10
featured_image: /wp-content/uploads/2015/05/12428002945_bc47ae3529_b-e1431393503428.jpg
tags:
- dnf
- fedora
- python
- systemd
- yum
title: Automatic package updates with dnf
---

![1]

With Fedora 22's release date [quickly approaching][2], it's time to familiarize yourself with dnf. It's especially important since clean installs of Fedora 22 won't have yum.

Almost all of the command line arguments are the same but automated updates are a little different. If you're used to yum-updatesd, then you'll want to look into [dnf-automatic][5].

## Installation

Getting the python code and systemd unit files for automated dnf updates is a quick process:

```
dnf -y install dnf-automatic
```


## Configuration

There's only one configuration file to review and most of the defaults are quite sensible. Open up `/etc/dnf/automatic.conf` with your favorite text editor and review the available options. The only adjustment I made was to change the **emit_via** option to _email_ as opposed to the _stdio_.

You may want to change the **email_to** option if you want to redirect email elsewhere. In my case, I already have an email forward for the root user.

## dnf Automation

If you look at the contents of the dnf-automatic package, you'll find some python code, configuration files, and two important systemd files:

For Fedora 25 and earlier:

```
# rpm -ql dnf-automatic | grep systemd
/usr/lib/systemd/system/dnf-automatic.service
/usr/lib/systemd/system/dnf-automatic.timer
```


For Fedora 26 and later:

```
# rpm -ql dnf-automatic | grep systemd
/usr/lib/systemd/system/dnf-automatic-download.service
/usr/lib/systemd/system/dnf-automatic-download.timer
/usr/lib/systemd/system/dnf-automatic-install.service
/usr/lib/systemd/system/dnf-automatic-install.timer
/usr/lib/systemd/system/dnf-automatic-notifyonly.service
/usr/lib/systemd/system/dnf-automatic-notifyonly.timer
```


These systemd files are what makes dnf-automatic run. The service file contains the instructions so that systemd knows what to run. The timer file contains the frequency of the update checks (defaults to one day). We need to enable the timer and then start it.

For Fedora 25 and earlier:

```
systemctl enable dnf-automatic.timer
```


For Fedora 26 and later:

```
systemctl enable dnf-automatic-install.timer
```


Check your work:

```
# systemctl list-timers *dnf*
NEXT                         LEFT     LAST                         PASSED    UNIT                ACTIVATES
Tue 2015-05-12 19:57:30 CDT  23h left Mon 2015-05-11 19:57:29 CDT  14min ago dnf-automatic.timer dnf-automatic.service
```


The output here shows that the dnf-automatic job last ran at 19:57 on May 11th and it's set to run at the same time tomorrow, May 12th. Be sure to disable and stop your yum-updatesd service if you still have it running on your system from a previous version of Fedora.

_Photo Credit: [Outer Rim Emperor][6] via [Compfight][7] [cc][8]_

 [1]: /wp-content/uploads/2015/05/12428002945_bc47ae3529_b-e1431393503428.jpg
 [2]: https://fedoraproject.org/wiki/Releases/22/Schedule
 [5]: http://dnf.readthedocs.org/en/latest/automatic.html
 [6]: https://www.flickr.com/photos/50899563@N07/12428002945/
 [7]: http://compfight.com
 [8]: https://www.flickr.com/help/general/#147