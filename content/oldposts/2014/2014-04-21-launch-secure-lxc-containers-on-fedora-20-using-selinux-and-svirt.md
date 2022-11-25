---
title: Launch secure LXC containers on Fedora 20 using SELinux and sVirt
author: Major Hayden
date: 2014-04-22T04:11:00+00:00
url: /2014/04/21/launch-secure-lxc-containers-on-fedora-20-using-selinux-and-svirt/
dsq_thread_id:
  - 3642807460
tags:
  - centos
  - containers
  - fedora
  - lxc
  - red hat
  - rhel
  - security
  - selinux
  - virtualization

---
![1]

Getting started with [LXC][2] is a bit awkward and I've assembled this guide for anyone who wants to begin experimenting with LXC containers in Fedora 20. As an added benefit, you can follow almost every step shown here when creating LXC containers on [Red Hat Enterprise Linux 7][3] Beta (which is based on Fedora 19).

You'll need a physical machine or a VM running Fedora 20 to get started. <span style="color: #888888">(You could put a container in a container, but things get a little dicey with that setup. Let's just avoid talking about nested containers for now. No, really, I shouldn't have even brought it up. Sorry about that.)</span>

### Prep Work

Start by updating all packages to the latest versions available:

```
yum -y upgrade
```

Verify that SELinux is in enforcing mode by running `getenforce`. If you see _Disabled_ or _Permissive_, get SELinux into enforcing mode with a quick configuration change:

```
sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
```

I recommend installing `setroubleshoot-server` to make it easier to find the root cause of AVC denials:

```yum -y install setroubleshoot-server
```

Reboot now. This will ensure that SELinux comes up in enforcing mode (verify that with `getenforce` after reboot) and it ensures that auditd starts up sedispatch (for setroubleshoot).

### Install management libraries and utilities

Let's grab libvirt along with LXC support and a basic NAT networking configuration.

```
yum -y install libvirt-daemon-lxc libvirt-daemon-config-network
```

Launch libvirtd via systemd and ensure that it always comes up on boot. This step will also adjust firewalld for your containers and ensure that dnsmasq is serving up IP addresses via DHCP on your default NAT network.

```
systemctl start libvirtd.service
systemctl enable libvirtd.service
```

### Bootstrap our container

Installing packages into the container's filesystem will take some time.

```
yum -y --installroot=/var/lib/libvirt/filesystems/fedora20 --releasever=20 --nogpg install systemd passwd yum fedora-release vim-minimal openssh-server procps-ng iproute net-tools dhclient
```

This step fills in the filesystem with the necessary packages to run a Fedora 20 container. We now need to tell libvirt about the container we've just created.

```
virt-install --connect lxc:// --name fedora20 --ram 512 --filesystem /var/lib/libvirt/filesystems/fedora20/,/
```

At this point, libvirt will know enough about the container to start it and you'll be connected to the console of the container! We need to adjust some configuration files within the container to use it properly. Detach from the console with CTRL-].

Let's stop the container so we can make some adjustments.

```
virsh -c lxc:// shutdown fedora20
```

### Get the container ready for production

Hop into your container and set a root password.

```
chroot /var/lib/libvirt/filesystems/fedora20 /bin/passwd root
```

We will be logging in as root via the console occasionally and we need to allow that access.

```
echo "pts/0" >> /var/lib/libvirt/filesystems/fedora20/etc/securetty
```

Since we will be using our NAT network with our auto-configured dnsmasq server (thanks to libvirt), we can configure a simple DHCP setup for eth0:

```
cat < < EOF > /var/lib/libvirt/filesystems/fedora20/etc/sysconfig/network
NETWORKING=yes
EOF
cat < < EOF > /var/lib/libvirt/filesystems/fedora20/etc/sysconfig/network-scripts/ifcfg-eth0
BOOTPROTO=dhcp
ONBOOT=yes
DEVICE=eth0
EOF
```

Using ssh makes the container a lot easier to manage, so let's ensure that it starts when the container boots. (You could do this via systemctl after logging in at the console, but I'm lazy.)

```
chroot /var/lib/libvirt/filesystems/fedora20/
ln -s /usr/lib/systemd/system/sshd.service /etc/systemd/system/multi-user.target.wants/
exit
```

### Launch!

Cross your fingers and launch the container.

```
virsh -c lxc:// start --console fedora20
```

You'll be attached to the console during boot but don't worry, hold down CTRL-] to get back to your host prompt. Check the dnsmasq leases to find your container's IP address and you can login as root over ssh.

```
cat /var/lib/libvirt/dnsmasq/default.leases
```

### Security

After logging into your container via ssh, check the process labels within the container:

```
# ps aufxZ
LABEL                           USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 1 0.0  1.3 47444 3444 ?      Ss   03:18   0:00 /sbin/init
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 18 0.0  2.0 43016 5368 ?     Ss   03:18   0:00 /usr/lib/systemd/systemd-journald
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 38 0.4  7.8 223456 20680 ?   Ssl  03:18   0:00 /usr/bin/python -Es /usr/sbin/firewalld -
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 40 0.0  0.7 26504 2084 ?     Ss   03:18   0:00 /usr/sbin/smartd -n -q never
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 41 0.0  0.4 19268 1252 ?     Ss   03:18   0:00 /usr/sbin/irqbalance --foreground
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 44 0.0  0.6 34696 1636 ?     Ss   03:18   0:00 /usr/lib/systemd/systemd-logind
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 46 0.0  1.8 267500 4832 ?    Ssl  03:18   0:00 /sbin/rsyslogd -n
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 dbus 47 0.0  0.6 26708 1680 ?     Ss   03:18   0:00 /bin/dbus-daemon --system --address=syste
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 rpc 54 0.0  0.5 41992 1344 ?      Ss   03:18   0:00 /sbin/rpcbind -w
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 55 0.0  0.3 25936 924 ?      Ss   03:18   0:00 /usr/sbin/atd -f
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 56 0.0  0.5 22728 1488 ?     Ss   03:18   0:00 /usr/sbin/crond -n
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 60 0.0  0.2 6412 784 pts/0   Ss+  03:18   0:00 /sbin/agetty --noclear -s console 115200
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 74 0.0  3.2 339808 8456 ?    Ssl  03:18   0:00 /usr/sbin/NetworkManager --no-daemon
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 394 0.0  5.9 102356 15708 ?  S    03:18   0:00  \_ /sbin/dhclient -d -sf /usr/libexec/nm
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 polkitd 83 0.0  4.4 514792 11548 ? Ssl 03:18   0:00 /usr/lib/polkit-1/polkitd --no-debug
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 rpcuser 110 0.0  0.6 46564 1824 ? Ss   03:18   0:00 /sbin/rpc.statd
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 111 0.0  1.3 82980 3620 ?    Ss   03:18   0:00 /usr/sbin/sshd -D
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 409 0.0  1.9 131576 5084 ?   Ss   03:18   0:00  \_ sshd: root@pts/1
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 413 0.0  0.9 115872 2592 pts/1 Ss 03:18   0:00      \_ -bash
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 438 0.0  0.5 123352 1344 pts/1 R+ 03:19   0:00          \_ ps aufxZ
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 411 0.0  0.8 44376 2252 ?    Ss   03:18   0:00 /usr/lib/systemd/systemd --user
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 412 0.0  0.5 66828 1328 ?    S    03:18   0:00  \_ (sd-pam)
system_u:system_r:virtd_lxc_t:s0-s0:c0.c1023 root 436 0.0  0.4 21980 1144 ?    Ss   03:19   0:00 /usr/lib/systemd/systemd-hostnamed
```

You'll notice something interesting if you run `getenforce` now within the container &#8212; SELinux is disabled. Actually, it's not really disabled. The processing of SELinux policy is done on the host. The container isn't able to see what's going on outside of its own files and processes. The [libvirt documentation for LXC][4] hints at the importance of this isolation:

> A suitably configured UID/GID mapping is a pre-requisite to making containers secure, in the absence of sVirt confinement.

> In the absence of the &#8220;user&#8221; namespace being used, containers cannot be considered secure against exploits of the host OS. The sVirt SELinux driver provides a way to secure containers even when the &#8220;user&#8221; namespace is not used. The cost is that writing a policy to allow execution of arbitrary OS is not practical. The SELinux sVirt policy is typically tailored to work with an simpler application confinement use case, as provided by the &#8220;libvirt-sandbox&#8221; project.

This leads to something really critical to understand:

### Containers don't contain

Dan Walsh has a [great post][5] that goes into the need for sVirt and the protections it can provide when you need to be insulated from potentially dangerous virtual machines or containers. If a user is root inside a container, they're root on the host as well. <span style="color: #888888">(There's an exception: <a href="https://lwn.net/Articles/436445/">UID namespaces</a>. But let's not talk about that now. Oh great, first it was nested containers and now I brought up UID namespaces. Sorry again.)</span>

Dan's talk about securing containers hasn't popped up on the [Red Hat Summit presentations][6] page quite yet but here are some notes that I took and then highlighted:

  * Containers don't contain. The kernel doesn't know about containers. Containers simply use kernel subsystems to carve up namespaces for applications.
  * Containers on Linux aren't complete. Don't compare directly to Solaris zones yet.
  * Running containers without Mandatory Access Control (MAC) systems like SELinux or AppArmor opens the door for full system compromise via untrusted applications and users within containers.

Using MAC gives you one extra barrier to keep a malicious container from getting higher levels of access to the underlying host. There's always a chance that a kernel exploit could bypass MAC but it certainly raises the level of difficulty for an attacker and allows server operators extra time to react to alerts.

 [1]: /wp-content/uploads/2013/07/selinux-penguin-new_medium.png
 [2]: https://en.wikipedia.org/wiki/LXC
 [3]: https://access.redhat.com/site/products/Red_Hat_Enterprise_Linux/Get-Beta
 [4]: http://libvirt.org/drvlxc.html#security
 [5]: https://danwalsh.livejournal.com/30565.html
 [6]: http://www.redhat.com/summit/2014/presentations/
