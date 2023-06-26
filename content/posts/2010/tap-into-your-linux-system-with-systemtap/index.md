---
aliases:
- /2010/12/07/tap-into-your-linux-system-with-systemtap/
author: Major Hayden
date: 2010-12-08 02:27:02
tags:
- advanced
- centos
- command line
- fedora
- kernel
- red hat
- sysadmin
- systemtap
- yum
title: Tap into your Linux system with SystemTap
---

One of the most interesting topics I've seen so far during my [RHCA][1] training at [Rackspace][2] this week is [SystemTap][3]. In short, SystemTap allows you to dig out a bunch of details about your running system relatively easily. It takes scripts, converts them to C, builds a kernel module, and then runs the code within your script.

**<span style="color: #D42020;">HOLD IT:</span> The steps below are _definitely_ not meant for those who are new to Linux. Utilizing SystemTap on a production system is a bad idea &#8212; it can chew up significant resources while it runs and it can also cause a running system to kernel panic if you're not careful with the packages you install.**

These instructions will work well with Fedora, CentOS and Red Hat Enterprise Linux. Luckily, the SystemTap folks put together some instructions for [Debian][4] and [Ubuntu][5] as well.

Before you can start working with SystemTap on your RPM-based distribution, you'll need to get some prerequisites together:

```
yum install gcc systemtap systemtap-runtime systemtap-testsuite kernel-devel
yum --enablerepo=*-debuginfo install kernel-debuginfo kernel-debuginfo-common
```

**<span style="color: #D42020;">WHOA THERE:</span> Ensure that the kernel-devel and kernel-debuginfo\* packages that you install via yum match up with your running kernel. If there's a newer kernel available from your yum repo, yum will pull that one. If it's been a while since you updated, you'll either need to upgrade your current kernel to the latest and reboot or you'll need to hunt down the corresponding kernel-devel and kernel-debuginfo\* packages from a repository. _Installing the wrong package version can lead to kernel panics._ Also, bear in mind that the debuginfo packages are quite large: almost 200MB in Red Hat/CentOS and almost 300MB in Fedora.**

You can't write the script in just any language. SystemTap uses an odd syntax to get things going:

```
#! /usr/bin/env stap
probe begin { println("hello world") exit () }
```

Just run the script with `stap`:

```
# stap -v helloworld.stp
Pass 1: parsed user script and 73 library script(s) using 94380virt/21988res/2628shr kb, in 140usr/30sys/167real ms.
Pass 2: analyzed script: 1 probe(s), 1 function(s), 0 embed(s), 0 global(s) using 94776virt/22516res/2692shr kb, in 10usr/0sys/5real ms.
Pass 3: using cached /root/.systemtap/cache/bc/stap_bc368822da380b943d4e845ee15ed047_773.c
Pass 4: using cached /root/.systemtap/cache/bc/stap_bc368822da380b943d4e845ee15ed047_773.ko
Pass 5: starting run.
hello world
Pass 5: run completed in 0usr/20sys/285real ms.
```

The `systemtap-testsuite` package gives you a **tubload** of extremely handy SystemTap scripts. For example:

```
# cd /usr/share/systemtap/testsuite/systemtap.examples/io/
# stap iotime.stp
15138470 6351 (httpd) access /usr/share/cacti/index.php read: 0 write: 0
15142243 6351 (httpd) access /usr/share/cacti/include/auth.php read: 0 write: 0
15143780 6351 (httpd) access /usr/share/cacti/include/global.php read: 0 write: 0
15144099 6351 (httpd) access /etc/cacti/db.php read: 0 write: 0
15187641 6351 (httpd) access /usr/share/cacti/lib/adodb/adodb.inc.php read: 106486 write: 0
15187664 6351 (httpd) iotime /usr/share/cacti/lib/adodb/adodb.inc.php time: 218
15194965 6351 (httpd) access /usr/share/cacti/lib/adodb/adodb-time.inc.php read: 0 write: 0
15195692 6351 (httpd) access /usr/share/cacti/lib/adodb/adodb-iterator.inc.php read: 0 write: 0
   ... output continues ...
```

The `iotime.stp` script dumps out the reads and writes occurring on the system in real time. After starting the script above, I accessed my cacti instance on the server and immediately started seeing some reads as apache began picking up PHP files to parse.

Consider a situation in which you need to decrease interrupts on a Linux machine. This is vital for laptops and systems that need to remain in low power states. Some might suggest powertop [for that, but why not give SystemTap a try?][6]

```
# cd /usr/share/systemtap/testsuite/systemtap.examples/interrupt/
# stap interrupts-by-dev.stp
        ohci_hcd:usb3 :      1
        ohci_hcd:usb4 :      1
            hda_intel :      1
                 eth0 :      2
                 eth0 :      2
                 eth0 :      2
                 eth0 :      2
                 eth0 :      2
                 eth0 :      2
```

On this particular system, it's pretty obvious that the ethernet interface is causing a lot of interrupts.

If you want more examples, keep hunting around in the systemtap-testsuite package (remember `rpm -ql systemtap-testsuite`) or review the [giant list of examples][7] on SystemTap's site.

_Thanks again to Phil Hopkins at Rackspace for giving us a detailed explanation of system profiling during training._

 [1]: https://www.redhat.com/courses/rh442_red_hat_enterprise_system_monitoring_and_performance_tuning/
 [2]: http://rackspace.com/
 [3]: http://sourceware.org/systemtap/
 [4]: http://sourceware.org/systemtap/wiki/SystemtapOnDebian
 [5]: http://sourceware.org/systemtap/wiki/SystemtapOnUbuntu
 [6]: http://www.lesswatts.org/projects/powertop/
 [7]: http://sourceware.org/systemtap/examples/