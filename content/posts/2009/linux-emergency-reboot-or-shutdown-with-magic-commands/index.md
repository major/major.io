---
aliases:
- /2009/01/29/linux-emergency-reboot-or-shutdown-with-magic-commands/
author: Major Hayden
date: 2009-01-30 02:07:06
tags:
- command line
- emergency
- kernel
- linux
- sysctl
title: 'Linux: emergency reboot or shutdown with magic commands'
---

Most linux distributions use some type of mechanism to gracefully stop daemons and unmount storage volumes during a reboot or shutdown. It's most commonly done via scripts that will wait for each daemon to shut down gracefully before proceeding to the next daemon.

As we know, sometimes servers misbehave due to things put them through, and you can quickly end up in a situation where things are going badly. I'm talking about the type of situation where you're connected via SSH to a server that controls phone lines for five million people and it sits in a tiny building 400 miles away from the nearest human being. We're talking bad. If you issue a plain `reboot` command, it might not even make it that far. Once SSH stops running, you're going to be out of luck.

If you find yourself in this situation (and I hope you won't!), you have some options to get your way with a misbehaving server remotely. You can force an immediate reboot with the following:

<pre lang="html">echo 1 > /proc/sys/kernel/sysrq 
echo b > /proc/sysrq-trigger</pre>

<span style="color: #ff0000;"><strong>WHOA THERE!</strong></span> This is pretty much the same as pressing the reset button on the server (if equipped). No daemons will be shut down gracefully, no filesystem sync will occur, and you may get the wrath of a fsck (or worse, a non-booting server) upon reboot. To do things a little more carefully, read on.

These are called [magic commands][1], and they're pretty much synonymous with holding down Alt-SysRq and another key on older keyboards. Dropping `1` into `/proc/sys/kernel/sysrq` tells the kernel that you want to enable SysRq access (it's usually disabled). The second command is equivalent to pressing Alt-SysRq-b on a QWERTY keyboard.

There's a better way of rebooting a misbehaving server that [Wikipedia shows][2] with the mnemonic &#8220;Reboot Even If System Utterly Broken&#8221;:

<pre lang="html">unRaw      (take control of keyboard back from X),
 tErminate (send SIGTERM to all processes),
 kIll      (send SIGKILL to all processes),
  Sync     (flush data to disk),
  Unmount  (remount all filesystems read-only),
reBoot.</pre>

I can't vouch for this actually working, but I'm interested to try it. **UPDATE:** I've been told that doing this series of commands with ReiserFS is a very bad idea.

If you want to shut the machine down entirely (please think about it before using this on a remote system):

<pre lang="html">echo 1 > /proc/sys/kernel/sysrq 
echo o > /proc/sysrq-trigger</pre>

If you want to keep SysRq enabled all the time, you can do that with an entry in your server's `sysctl.conf`:

<pre lang="html">kernel.sysrq = 1</pre>

 [1]: http://en.wikipedia.org/wiki/Magic_SysRq_key
 [2]: http://en.wikipedia.org/wiki/Magic_SysRq_key#.22Raising_Elephants.22_mnemonic_device