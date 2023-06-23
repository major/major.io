---
aliases:
- /2013/04/25/limit-access-to-the-su-command/
author: Major Hayden
date: 2013-04-26 04:05:46
dsq_thread_id:
- 3642807235
tags:
- centos
- command line
- fedora
- pam
- red hat
- security
- sysadmin
title: Limit access to the su command
---

The wheel group exists for a critical purpose and Wikipedia has a [concise definition][1]:

> In computing, the term wheel refers to a user account with a wheel bit, a system setting that provides additional special system privileges that empower a user to execute restricted commands that ordinary user accounts cannot access. The term is derived from the slang phrase big wheel, referring to a person with great power or influence. 

On Red Hat systems (including Fedora), the default `sudo` configuration allows users in the wheel group to use sudo while all others are restricted from using it in `/etc/sudoers`:

```
## Allows people in group wheel to run all commands
%wheel        ALL=(ALL)       ALL
```


However, the `su` command can be used by all users by default (which is something I often forget). Fixing it is easy once you take a look at `/etc/pam.d/su`:

```
# Uncomment the following line to require a user to be in the "wheel" group.
#auth		required	pam_wheel.so use_uid
```


Uncomment the line and access to `su` will only be available for users in the wheel group.

 [1]: http://en.wikipedia.org/wiki/Wheel_(Unix_term)