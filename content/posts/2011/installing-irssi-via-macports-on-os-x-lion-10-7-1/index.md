---
aliases:
- /2011/09/30/installing-irssi-via-macports-on-os-x-lion-10-7-1/
author: Major Hayden
date: 2011-09-30 13:24:44
tags:
- command line
- gcc
- irc
- irssi
- mac
- macports
title: Installing irssi via MacPorts on OS X Lion 10.7.1
---

I've floated back and forth between graphical IRC clients and terminal-based clients for a long time. However, I was sad to see that irssi wouldn't build via MacPorts on OS X Lion. During the build, I saw quite a few errors from the compiler:

```
-E, -S, -save-temps and -M options are not allowed with multiple -arch flags
```


Sure enough, when I looked at the lines in the output, both x86_64 and i386 were passed to the compiler:

```
... -pipe -O2 -arch x86_64 -arch i386 -fno-common ...
```


I [opened a ticket in trac][1] and began looking for a workaround. [Another trac ticket][2] (from four years ago) on the MacPorts site gave some pointers on how to work around the bug for a previous version.

I changed up the instructions a bit since we're not dealing with the ppc architecture any longer:

```
sudo port -v clean irssi +perl
sudo port -v configure irssi +perl
cd /opt/local/var/macports/build/_opt_local_var_macports_sources_rsync.macports.org_release_tarballs_ports_irc_irssi/irssi/work/
sudo find . -type f -exec sed -i "" -e "s/-arch i386//g" {} \;
cd
sudo port -v install irssi +perl
```


The build worked!

```
$ irssi -v
irssi 0.8.15 (20100403 1617)
```


 [1]: http://trac.macports.org/ticket/31467
 [2]: http://trac.macports.org/ticket/13004#comment:4