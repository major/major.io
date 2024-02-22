---
aliases:
- /2013/07/05/confine-untrusted-users-including-your-children-with-selinux/
author: Major Hayden
date: 2013-07-05 18:50:43
tags:
- centos
- command line
- fedora
- redhat
- security
- selinux
- sysadmin
title: Confine untrusted users (including your children) with SELinux
---

[<img src="https://major.io/wp-content/uploads/2011/09/selinux-penguin-125.png" alt="SELinux Penguin" width="125" height="113" class="alignright size-full wp-image-2532" />][1]The [confined user support in SELinux][2] is handy for ensuring that users aren't able to do something that they shouldn't. It seems more effective and easier to use than most of the other methods I've seen before. Thanks to Dan for reminding me about this during his [SELinux in the Enterprise][3] talk from this year's Red Hat Summit.

There are five main SELinux user types (and a [handy chart][4] in the Fedora documentation):

  * **guest_u:** - no X windows, no sudo, and no networking
  * **xguest_u:** - same as guest_u, but X is allowed and connectivity is allowed to web ports only (handy for kiosks)
  * **user_u:** - same as xguest_u, but networking isn't restricted
  * **staff_u:** - same as user_u, but sudo is allowed (su isn't allowed)
  * **unconfined_u:** - full access (this is the default)

One interesting thing to note is that all users are allowed to execute binary applications within their home directories by default. This can be switch off via some booleans (which I'll demonstrate in a moment).

Let's kick off a demonstration to show the power of these restrictions. First off, let's get a list of the default configuration:

```
# semanage login -l

Login Name           SELinux User         MLS/MCS Range        Service

__default__          unconfined_u         s0-s0:c0.c1023       *
root                 unconfined_u         s0-s0:c0.c1023       *
system_u             system_u             s0-s0:c0.c1023       *
```


By default, all new users come with no restrictions (as shown by unconfined_u). I'll create a new user called selinuxtest and set a password. If I ssh to the server as the selinuxtest user, I see that I'm unconfined:

```
$ id -Z
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```


That's what we expected. Let's apply the strongest restrictions to this user and apply guest_u:

```
# semanage login -a -s guest_u selinuxtest
```


I'll start a new ssh session as selinuxtest and try out some commands that I'd normally expect to work on a Linux server:

```
$ ping google.com
ping: icmp open socket: Permission denied
$ curl google.com
curl: (7) Failed to connect to 74.125.225.129: Permission denied
$ sudo su -
sudo: unable to change to sudoers gid: Operation not permitted
$  ./hello
Hello world
$ file hello
hello: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=0x5ffb25a7171c3338d6c76147cccc666ddc752dde, not stripped
```


The networking and sudo restrictions applied as we expected. However, I was able to compile a small "Hello World" binary in C and run it. That could become a problem for some servers. Let's adjust a boolean that will restrict this activity:

```
# getsebool -a | grep exec_content
auditadm_exec_content --> on
guest_exec_content --> on
secadm_exec_content --> on
staff_exec_content --> on
sysadm_exec_content --> on
user_exec_content --> on
xguest_exec_content --> on
# setsebool guest_exec_content off
```


Now I try running the binary again as my selinuxtest user:

```
$ ./hello
-bash: ./hello: Permission denied
```


I can't execute binary content in my home directory or in /tmp any longer after adjusting the boolean. Let's switch selinuxtest to xguest_u:

```
# semanage login -a -s xguest_u selinuxtest
```


And now I'll re-test as the selinuxtest user:

```
$ curl -si google.com | head -1
HTTP/1.1 301 Moved Permanently
$ ping google.com
ping: icmp open socket: Permission denied
```


I have full web connectivity but I can't do anything else on the network. Now for a switch to user_u:

```
# semanage login -a -s user_u selinuxtest
```


And testing user_u with selinuxtest reveals:

```
$ ping -c 1 google.com
PING google.com (74.125.225.134) 56(84) bytes of data.
64 bytes from ord08s09-in-f6.1e100.net (74.125.225.134): icmp_seq=1 ttl=57 time=29.3 ms

--- google.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 29.332/29.332/29.332/0.000 ms
$ curl -si google.com | head -n1
HTTP/1.1 301 Moved Permanently
$ sudo su -
sudo: PERM_SUDOERS: setresuid(-1, 1, -1): Operation not permitted
```


Networking is wide open but I still don't have sudo. Let's try staff_u:

```
# semanage login -a -s staff_u selinuxtest
```


Testing staff_u with selinuxtest gives me the expected results:

```
$ sudo su -
[sudo] password for selinuxtest:
```


I didn't add selinuxtest to sudoers, so this command would fail. However, I'm actually allowed to execute it now.

These restrictions could be very helpful when dealing with users that you don't fully trust on your system. You could use these restrictions to add a kiosk user to a Linux machine and allow family members or coworkers to surf the web using your device. In addition, you could use the restrictions as an extra layer of protection on heavily shared servers to prevent users from consuming resources or generating malicious traffic.

 [1]: https://major.io/wp-content/uploads/2011/09/selinux-penguin-125.png
 [2]: https://danwalsh.livejournal.com/10461.html?thread=88029
 [3]: https://rhsummit.files.wordpress.com/2013/06/summitselinuxenterprise.pdf
 [4]: https://docs.fedoraproject.org/en-US/Fedora/12/html/Security-Enhanced_Linux/sect-Security-Enhanced_Linux-Targeted_Policy-Confined_and_Unconfined_Users.html
