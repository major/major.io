---
aliases:
- /2013/07/06/boot-vms-with-virt-manager-and-libvirt-with-isos-stored-remotely-via-sambacifs/
author: Major Hayden
date: 2013-07-07 01:51:10
tags:
- command line
- fedora
- linux
- red hat
- samba
- virtualization
title: Boot VM’s with virt-manager and libvirt with ISO’s stored remotely via samba/cifs
---

![1]

Pairing [virt-manager][2] with KVM makes booting new VM's pretty darned easy. I have a [QNAP NAS][3] at home with a bunch of ISO's stored in share available to guests and I wanted to use that with libvirt to boot new VM's. (By the way, if you're looking for an off-the-shelf NAS that is built with solid hardware and pretty reliable software, try one of the QNAP devices. You still get access to many of the usual commands that you would normally find on a Linux box for emergencies. More on that in a later post.)

The first step was creating a mountpoint and configuring the mount in /etc/fstab:

```
# mkdir /mnt/iso
# grep qemu /etc/passwd
qemu:x:107:107:qemu user:/:/sbin/nologin
# echo "//qnap/ISO /mnt/iso cifs    _netdev,guest,uid=107,gid=107,defaults 0 0" >> /etc/fstab
# mount /mnt/iso
```

My QNAP is already in /etc/hosts so I didn't need to specify the IP in the file. Adding `_netdev` ensures that the network will be up before the mount is made. The `guest` option ensures that I won't be prompted for credentials and the `uid=107,gid=107` mounts the share as the qemu user. If you forget this, virt-manager will throw some ugly permissions errors from libvirt.

From there, I had another permissions error and I suspected that SELinux was preventing libvirt from accessing the files in the share. A quick check of /var/log/messages revealed that I was right:

```
Jul  6 16:12:51 nuc1 setroubleshoot: SELinux is preventing /usr/bin/qemu-system-x86_64 from open access on the file /mnt/iso/livecd.iso. For complete SELinux messages. run sealert -l c1c80b2c-b5df-4114-86c7-ffee98274552
```

Here's the output from sealert:

```
# sealert -l c1c80b2c-b5df-4114-86c7-ffee98274552
SELinux is preventing /usr/bin/qemu-system-x86_64 from open access on the file /mnt/iso/livecd.iso.

*****  Plugin catchall_boolean (89.3 confidence) suggests  *******************

If you want to allow virt to use samba
Then you must tell SELinux about this by enabling the 'virt_use_samba' boolean.
You can read 'None' man page for more details.
Do
setsebool -P virt_use_samba 1
```

The fix is a quick one:

```
# setsebool -P virt_use_samba 1
```

You should be all set after that. Press &#8220;Browse Local&#8221; in virt-manager when you look for your ISO to boot the virtual machine and navigate over to /mnt/iso for your list of ISO's.

 [1]: https://major.io/wp-content/uploads/2013/07/qnap.jpg
 [2]: http://virt-manager.org/
 [3]: http://www.qnap.com/en/?lang=en&sn=822&c=1655&sc=1656&t=1660&n=6703