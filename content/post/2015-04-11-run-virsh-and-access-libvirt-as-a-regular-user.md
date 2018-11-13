---
title: Run virsh and access libvirt as a regular user
author: Major Hayden
type: post
date: 2015-04-11T15:30:54+00:00
url: /2015/04/11/run-virsh-and-access-libvirt-as-a-regular-user/
dsq_thread_id:
  - 3673129597
categories:
  - Blog Posts
tags:
  - fedora
  - libvirt
  - linux
  - security

---
[<img src="/wp-content/uploads/2015/04/libvirtLogo-300x241.png" alt="libvirt logo" width="300" height="241" class="alignright size-medium wp-image-5474" srcset="/wp-content/uploads/2015/04/libvirtLogo-300x241.png 300w, /wp-content/uploads/2015/04/libvirtLogo.png 344w" sizes="(max-width: 300px) 100vw, 300px" />][1][Libvirt][2] is a handy way to manage containers and virtual machines on various systems. On most distributions, you can only access the libvirt daemon via the root user by default. I'd rather use a regular non-root user to access libvirt and limit that access via groups.

<!--more-->

Modern Linux distributions use [Polkit][3] to limit access to the libvirt daemon. You can add an extra rule to the existing set of Polkit rules to allow regular users to access libvirtd. Here's an example rule (in Javascript) from the [ArchWiki][4]:

```
/* Allow users in kvm group to manage the libvirt
daemon without authentication */
polkit.addRule(function(action, subject) {
    if (action.id == "org.libvirt.unix.manage" &&
        subject.isInGroup("wheel")) {
            return polkit.Result.YES;
    }
});
```


As shown on the ArchWiki, I saved this file as `/etc/polkit-1/rules.d/49-org.libvirt.unix.manager.rules`. I'm using the _wheel_ group to govern access to the libvirt daemon but you could use any group you choose. Just update the `subject.isInGroup` line in the rules file. You shouldn't have to restart any daemons after adding the new rule file.

I'm now able to run virsh as my regular user:

```
[major@host ~]$ id
uid=1000(major) gid=1000(major) groups=1000(major),10(wheel) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
[major@host ~]$ virsh list --all
 Id    Name                           State
----------------------------------------------------

```


 [1]: /wp-content/uploads/2015/04/libvirtLogo.png
 [2]: http://libvirt.org/
 [3]: http://en.wikipedia.org/wiki/Polkit
 [4]: https://wiki.archlinux.org/index.php/Libvirt#Using_polkit
