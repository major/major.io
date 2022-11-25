---
title: Install sysstat on Fedora 21
author: Major Hayden
date: 2014-12-12T17:55:57+00:00
url: /2014/12/12/install-sysstat-fedora-21/
dsq_thread_id:
  - 3642807769
tags:
  - centos
  - command line
  - debian
  - fedora
  - red hat
  - sysadmin
  - ubuntu

---
One of the first tools I learned about after working with Red Hat was [sysstat][1]. It can write down historical records about your server at regular intervals. This can help you diagnose CPU usage, RAM usage, or network usage problems. In addition, sysstat also provides some handy command line utilities like [vmstat][2], [iostat][3], and [pidstat][4] that give you a live view of what your system is doing.

On Debian-based systems (including Ubuntu), you install the sysstat package and enable it with a quick edit to `/etc/default/sysstat` and the cron job takes it from there. CentOS and Fedora systems call the collector process using a cron job in `/etc/cron.d` and it's enabled by default.

Fedora 21 comes with sysstat 11 and there are now systemd unit files to control the collection and management of stats. You can find the unit files by listing the files in the sysstat RPM:

```
$ rpm -ql sysstat | grep systemd
/usr/lib/systemd/system/sysstat-collect.service
/usr/lib/systemd/system/sysstat-collect.timer
/usr/lib/systemd/system/sysstat-summary.service
/usr/lib/systemd/system/sysstat-summary.timer
/usr/lib/systemd/system/sysstat.service
```


These services and timers **aren't enabled by default** in Fedora 21. If you run `sar` after installing sysstat, you'll see something like this:

```
# sar
Cannot open /var/log/sa/sa12: No such file or directory
Please check if data collecting is enabled
```


All you need to do is enable and start the main sysstat service:

```
systemctl enable sysstat
systemctl start sysstat
```


From there, systemd will automatically call for collection and management of the statistics using its [internal timers][5]. Opening up `/usr/lib/systemd/system/sysstat-collect.timer` reveals the following:

```ini
# /usr/lib/systemd/system/sysstat-collect.timer
# (C) 2014 Tomasz Torcz <tomek@pipebreaker.pl>
#
# sysstat-11.0.0 systemd unit file:
#        Activates activity collector every 10 minutes

[Unit]
Description=Run system activity accounting tool every 10 minutes

[Timer]
OnCalendar=*:00/10

[Install]
WantedBy=sysstat.service
```


The timer unit file ensures that the sysstat-collect.service is called every 10 minutes based on the real time provided by the system clock. (There are other options to set timers based on relative time of when the server booted or when a user logged into the system). The familiar `sa1` command appears in `/usr/lib/systemd/system/sysstat-collect.service`:

```ini
# /usr/lib/systemd/system/sysstat-collect.service
# (C) 2014 Tomasz Torcz <tomek@pipebreaker.pl>
#
# sysstat-11.0.0 systemd unit file:
#        Collects system activity data
#        Activated by sysstat-collect.timer unit

[Unit]
Description=system activity accounting tool
Documentation=man:sa1(8)

[Service]
Type=oneshot
User=root
ExecStart=/usr/lib64/sa/sa1 1 1
```


 [1]: http://sebastien.godard.pagesperso-orange.fr/
 [2]: http://linux.die.net/man/8/vmstat
 [3]: http://linux.die.net/man/1/iostat
 [4]: http://linux.die.net/man/1/pidstat
 [5]: http://www.freedesktop.org/software/systemd/man/systemd.timer.html
