---
aliases:
- /2007/02/13/chmod-and-the-mysterious-first-octet/
author: Major Hayden
date: 2007-02-14 04:00:52
dsq_thread_id:
- 3642765415
tags:
- command line
- security
title: Chmod and the mysterious first octet
---

If you've ever worked on a linux system, chances are that you've used chmod many times. However, the quickest way to stump many linux users is to ask how many octets a full permissions set has. Many people think of this and say three:

`chmod 777 file`

But what you're actually saying:

`chmod 0777 file`

The first octet works the same way as the other three as it has 3 possible values that add to make the octet (for the letter-lovers, i've included those too):

`4 - setuid (letter-style: s)<br />
2 - setgid (letter-style: s)<br />
1 - sticky bit (letter-style: t)`

Remember - your first octet will **always be reset to 0** when using chown or chgrp on files.

**Setuid**

If you setuid on a binary, you're telling the operating system that you want this binary to always be executed as the user owner of the binary. So, let's say the permissions on a binary are set like so:

`# chmod 4750 some_binary<br />
# ls -al some_binary<br />
-rwsr-x--- 1 root users 0 Feb 13 21:43 some_binary`

You'll notice the small 's' in the user permissions blocks - this means that if a user on the system executes this binary, it will run as root with full root permissions. Obviously, anyone in the users group can run this binary since the execute bit is set for the group, but when the binary runs, it will run with root permissions. **Be smart with setuid!** Anything higher than 4750 can be very dangerous as it allows the world to run the binary as the root user. Also, if you allow full access plus setgid, you will be opening yourself up for something mighty nasty:

`# chmod 4777 some_binary<br />
# ls -al some_binary<br />
-rwsrwxrwx 1 root users 0 Feb 13 21:43 some_binary`

Not only can every user on the system execute this binary, but they can **edit it** before it runs at **root**! It goes without saying, but this could be used to beat up your system pretty badly. If you neglect to allow enough user permissions for execution, linux laughs at you by throwing the uppercase 'S' into your terminal:

`# chmod 4400 some_binary<br />
# ls -al some_binary<br />
-r-S------ 1 root users 0 Feb 13 21:43 some_binary`

Since no one can execute this script anyways (except root), you get the big capital 'S' for 'Silly'. (It probably doesn't stand for silly, but whatever.)

**Setgid**

Setgid is pretty much the exact same as setuid, but the binary runs with the privileges of the owner group rather than the user's primary group privileges. This isn't quite so useful in my opinion, but in case you need it, here's how the permissions come out:

`# chmod 2750 some_binary<br />
# ls -al some_binary<br />
-rwxr-s--- 1 root users 0 Feb 13 21:43 some_binary`

And if you enjoy being made fun of:

`# chmod 2400 some_binary<br />
# ls -al some_binary<br />
-r----S--- 1 root users 0 Feb 13 21:43 some_binary`

**Sticky Bit**

This is such a giggly term for a linux file permission, but it's rather important, and it best applies to your tmp directory (or any other world writable location). Since world writable locations allow users to go hog-wild with creating, editing, appending, and deleting files, this can get annoying if certain users share a common directory.

Let's say users work in an office and they work on files in a world writeable directory. One user gets mad because another user got a raise, so they trash all of the files that belong to that recently promoted user. Obviously, this could lead to a touchy situation. If you apply the sticky bit on the directory, the users can do anything they want to files they create, but they can't write to or delete files which they didn't create. Pretty slick, er, sticky, right? Here's how to set the sticky bit:

`#chmod 1777 /tmp<br />
# ls -ld /tmp<br />
drwxrwxrwt 3 root root 4096 Feb 13 21:57 /tmp`

And again, linux will laugh at you for setting sticky bits on non-world writable directories, but this time it does so with a capital 'T':

`#chmod 1744 /tmp<br />
# ls -ld /tmp<br />
drw-r--r-T 3 root root 4096 Feb 13 21:57 /tmp`

**Setuid + Setgid on Directories**

Setting the setgid bit on a directory means any files created in that directory will be owned by the group who owns the directory. No matter what your primary group is, any files you make will be owned by the group who owns the directory.

Setting the setuid bit on a directory has no effect in almost all Linux variants. However, in FreeBSD, it acts the same as the setgid (except it changes the ownership of new files as the user who owns the folder).