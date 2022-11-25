---
title: SELinux and .forward files
author: Major Hayden
date: 2012-01-02T22:44:43+00:00
url: /2012/01/02/selinux-and-forward-files/
dsq_thread_id:
  - 3642806728
tags:
  - command line
  - fedora
  - mail
  - postfix
  - redhat
  - security
  - selinux
  - sysadmin

---
If you want to forward e-mail from root to another user, you can usually place a `.forward` file in root's home directory and your mail server will take care of the rest:

```
 /root/.forward
```


With SELinux, you'll end up getting an AVC denial each time your mail server tries to read the contents of the `.forward` file:

```
type=AVC msg=audit(1325543823.787:7416): avc:  denied  { open } for  pid=9850
  comm="local" name=".forward" dev=md0 ino=17694734
  scontext=system_u:system_r:postfix_local_t:s0
  tcontext=unconfined_u:object_r:admin_home_t:s0 tclass=file
```


The reason is that your `.forward` file doesn't have the right SELinux contexts. You can set the correct contest quickly with `restorecon`:

```
# ls -Z /root/.forward
-rw-r--r--. root root unconfined_u:object_r:admin_home_t:s0 /root/.forward
# restorecon -v /root/.forward
restorecon reset /root/.forward context unconfined_u:object_r:admin_home_t:s0->system_u:object_r:mail_forward_t:s0
# ls -Z /root/.forward
-rw-r--r--. root root system_u:object_r:mail_home_t:s0 /root/.forward
```


Try to send another e-mail to root and you should see the mail server forward the e-mail properly without any additional AVC denials.
