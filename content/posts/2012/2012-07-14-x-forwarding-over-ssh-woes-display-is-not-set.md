---
title: 'X forwarding over ssh woes: DISPLAY is not set'
author: Major Hayden
type: post
date: 2012-07-14T19:56:09+00:00
url: /2012/07/14/x-forwarding-over-ssh-woes-display-is-not-set/
dsq_thread_id:
  - 3642807009
categories:
  - Blog Posts
tags:
  - centos
  - fedora
  - linux
  - redhat
  - security
  - ssh
  - sysadmin

---
This problem came up in conversation earlier this week and I realized that I'd never written a post about it. Has this ever happened to you before?

```
$ ssh -YC remotebox
[major@remotebox ~]$ xterm
xterm: Xt error: Can't open display:
xterm: DISPLAY is not set
```


I've scratched my head on this error message when the remote server is a minimally-installed CentOS, Fedora, or Red Hat system. It turns out that the **xorg-x11-xauth** package wasn't installed with the minimal package set and I didn't have any [authentication credentials ready][1] to hand off to the X server on the remote machine.

Luckily, the fix is a quick one:

```
[root@remotebox ~]# yum -y install xorg-x11-xauth
```


Close the ssh connection to your remote server and give it another try:

```
$ ssh -YC remotebox
[major@remotebox ~]$ xterm
```


You should now have an xterm from the remote machine on your local computer.

The source of the problem is that you don't have a MIT-MAGIC-COOKIE on the remote system. The [Xsecurity][2] man page explains it fairly well:

> MIT-MAGIC-COOKIE-1

> When using MIT-MAGIC-COOKIE-1, the client sends a 128 bit "cookie" along with the connection setup information. If the cookie presented by the client matches one that the X server has, the connection is allowed access. The cookie is chosen so that it is hard to guess; xdm generates such cookies automatically when this form of access control is used. The user's copy of the cookie is usually stored in the .Xauthority file in the home directory, although the environment variable XAUTHORITY can be used to specify an alternate location. Xdm automatically passes a cookie to the server for each new login session, and stores the cookie in the user file at login.

Your home directory on the remote server should have a small file called **.Xauthority** with the magic cookie in binary:

```
[major@remotebox ~]$ ls -al ~/.Xauthority
-rw-------. 1 major major 61 Jul 14 19:28 /home/major/.Xauthority
[major@remotebox ~]$ file ~/.Xauthority
/home/major/.Xauthority: data
```


 [1]: http://www.x.org/wiki/Development/Documentation/Security
 [2]: http://www.x.org/archive/X11R6.8.1/doc/Xsecurity.7.html
