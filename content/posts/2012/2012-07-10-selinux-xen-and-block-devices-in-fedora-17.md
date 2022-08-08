---
title: SELinux, Xen, and block devices in Fedora 17
author: Major Hayden
date: 2012-07-10T05:05:33+00:00
url: /2012/07/10/selinux-xen-and-block-devices-in-fedora-17/
dsq_thread_id:
  - 3642807008
tags:
  - fedora
  - security
  - selinux
  - sysadmin
  - virtualization
  - xen

---
If you try to run Xen without libvirt on Fedora 17 with SELinux in enforcing mode, you'll be butting heads with SELinux in no time. You'll probably be staring at something like this:

```
# xm create -c fedora17
Using config file "/etc/xen/fedora17".
Error: Disk isn't accessible
```


If you have `setroubleshoot` and `setroubleshoot-server` installed, you should have a friendly message in /var/log/messages telling you the source of the problem:

```
setroubleshoot: SELinux is preventing /usr/bin/python2.7 from read access on the blk_file dm-1.
For complete SELinux messages. run sealert -l 4d890105-d9a4-4b3e-a674-ba7e952942dc
```


The Xen daemon (the python process mentioned in the SELinux denial) is running with a context type of `xend_t` but the block device I'm trying to use for the VM has `fixed_disk_device_t`:

```
# ps axZ | grep xend
system_u:system_r:xend_t:s0       953 ?        SLl    0:40 /usr/bin/python /usr/sbin/xend
# ls -alZ /dev/dm-1
brw-rw----. root disk system_u:object_r:fixed_disk_device_t:s0 /dev/dm-1
```


SELinux isn't going to allow this to work. However, even if we fix this, SELinux will balk about three additional issues and we'll need to adjust the contexts on every new fixed block device we make. To get over the hump, change the context type on your block device to `xen_image_t` and re-run the `xm create`:

```
# chcon -t xen_image_t /dev/dm-1
# ls -alZ /dev/dm-1
brw-rw----. root disk system_u:object_r:xen_image_t:s0 /dev/dm-1
# xm create -c fedora17
Using config file "/etc/xen/fedora17".
Error: out of pty devices
```


You'll find three new denials in /var/log/messages:

```
setroubleshoot: SELinux is preventing /usr/bin/python2.7 from read access on the file group.
For complete SELinux messages. run sealert -l b1392df4-dda4-4b82-914c-1e20c62fc898
setroubleshoot: SELinux is preventing /usr/bin/python2.7 from setattr access on the chr_file 1.
For complete SELinux messages. run sealert -l 3e09edc3-aeb7-49f5-96e1-d8148afda48f
setroubleshoot: SELinux is preventing /usr/bin/python2.7 from execute access on the file pt_chown.
For complete SELinux messages. run sealert -l 86395f09-5f33-4f66-8d02-519b61e54139
```


As much as it pains me to suggest it, you can create a custom module to allow all four of these operations by xend:

```
# grep xend /var/log/audit/audit.log | audit2allow -M custom_xen
WARNING: Policy would be downgraded from version 27 to 26.
******************** IMPORTANT ***********************
To make this policy package active, execute:

semodule -i custom_xen.pp

# semodule -i custom_xen.pp
```


You should now be able to start your VM without any complaints from SELinux. I'll reiterate that this isn't ideal, but it's the best balance of security and convenience that I've found so far.
