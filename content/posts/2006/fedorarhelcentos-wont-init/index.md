---
aliases:
- /2006/12/28/fedorarhelcentos-wont-init/
author: Major Hayden
date: 2006-12-29 00:35:13
dsq_thread_id:
- 3679080831
tags:
- emergency
title: Fedora/RHEL/Centos Won’t Init
---

In the event that a Fedora/RHEL/CentOS box won't perform the init (which comes right after the initial kernel load), don't fret - it can be fixed. Make a note of the missing libraries or executables. Simply boot onto a livecd or rescuecd and chroot into your main installation. Once you're chrooted, just forcefully install any RPM's which might contain files that are missing when the init is loaded.

Forcing the installation of an RPM:

> rpm -ivh -force filename.rpm</blockquote >
>
> Listing the files that an installed RPM contains:
>
> > rpm -ql rpmname
>
> Listing the files that an RPM file contains:
>
> > rpm -qpl filename.rpm
>
> Finding the RPM that contains a certain file/executable:
>
> > rpm -qf /usr/bin/filename
>
> Figuring out what might be wrong with files already installed from an RPM:
>
> > rpm -V rpmname