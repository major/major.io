---
title: Installing the Xen hypervisor on Fedora 19
author: Major Hayden
type: post
date: 2013-06-03T04:27:43+00:00
url: /2013/06/02/installing-the-xen-hypervisor-on-fedora-19/
dsq_thread_id:
  - 3642807297
categories:
  - Blog Posts
tags:
  - command line
  - fedora
  - kernel
  - linux
  - security
  - selinux
  - sysadmin
  - virtualization
  - xen
  - yum

---
It's been a little while [since I last posted about installing Xen on Fedora][1], so I figured that Fedora 19's beta release was as good a time as any to write a new post. To get started, you'll need to get Fedora 19 installed on your favorite hardware (or virtual machine).

Install the Xen hypervisor and tools. Also, ensure that both of the necessary daemons are running on each boot:

```
yum -y install xen xen-hypervisor xen-libs xen-runtime
chkconfig xend on
chkconfig xendomains on
```


You'll notice that I didn't start the daemons quite yet. We will need the xen hypervisor running before they will be of any use.

Now, let's configure GRUB2. I wrote a [quick post about these steps][2] last year. The Xen kernel entry should already be configured (by grubby), but it's not the default. Fixing that is a quick process:

```
# grep ^menuentry /boot/grub2/grub.cfg | cut -d "'" -f2
Fedora, with Linux 3.9.4-300.fc19.x86_64
Fedora, with Linux 0-rescue-4ea51ecfff4f4e64a5ec903c495ee5b6
Fedora, with Xen hypervisor
# grub2-set-default 'Fedora, with Xen hypervisor'
# grub2-editenv list
saved_entry=Fedora, with Xen hypervisor
```


At this point, you're ready to reboot. After the reboot, verify that Xen is running:

```
# xm dmesg | head
 __  __            _  _    ____    ____    ____    __      _  ___
 \ \/ /___ _ __   | || |  |___ \  |___ \  | ___|  / _| ___/ |/ _ \
  \  // _ \ '_ \  | || |_   __) |   __) |_|___ \ | |_ / __| | (_) |
  /  \  __/ | | | |__   _| / __/ _ / __/|__|__) ||  _| (__| |\__, |
 /_/\_\___|_| |_|    |_|(_)_____(_)_____| |____(_)_|  \___|_|  /_/

(XEN) Xen version 4.2.2 (mockbuild@phx2.fedoraproject.org) (gcc (GCC) 4.8.0 20130412 (Red Hat 4.8.0-2)) Fri May 17 19:39:53 UTC 2013
(XEN) Latest ChangeSet: unavailable
(XEN) Bootloader: GRUB 2.00
(XEN) Command line: placeholder
```


If you're adventurous on the command line, you're done here. However, I enjoy using virt-manager for quick access to virtual machines and I also like all of the scripting and remote administration capabilities that libvirt delivers. Let's get the tools and daemons installed and running:

```
yum -y install virt-manager dejavu* xorg-x11-xauth
yum -y install libvirt-daemon-driver-network libvirt-daemon-driver-storage libvirt-daemon-xen
chkconfig libvirtd on
service libvirtd start
```


You're now ready to use virt-manager to manage your virtual machines. Simply ssh to your hypervisor with X forwarding enabled (`ssh -X hypervisor.mydomain.com`) and run `virt-manager`. You won't have a virtual network or bridge to use for virtual machines quite yet. You have two options: NAT your VM's or configure a network bridge. I prefer the bridge but you may require something different in your environment.

For the NAT option (the easiest for beginners):

```
yum -y install libvirt-daemon-config-network libvirt-daemon-config-nwfilter
service libvirtd restart
```


For the network-bridge option, you'll need to adjust your network scripts to create a bridge and add your primary network interface to the bridge. That's a bit outside the scope of this post, but the [Fedora Wiki][3] and [HowtoForge][4] (ignore the KVM parts of their guide).

**You now have a working Xen installation on Fedora 19!**

<strong style="color: #D42020;">FOR THOSE WHO EMBRACE SECURITY:</strong>

If you run SELinux in Enforcing mode, there's still a lingering issue where SELinux prevents python (running under xend) from talking to block devices (like logical volumes). I [opened a bug][5] about a similar problem before but I need to open another one for the block device issue. If you're itching for a workaround, you can force SELinux into permissive mode for the xend_t context only:

```
yum -y install selinux-policy-devel
semanage permissive -a xend_t
```


That's not the best option for now, but it's certainly better than `setenforce 0`. ;)

 [1]: /2011/08/05/xen-4-1-on-fedora-15-with-linux-3-0/
 [2]: /2012/07/16/boot-the-xen-hypervisor-by-default-in-fedora-17-with-grub-2/
 [3]: http://fedoraproject.org/wiki/Networking/Bridging
 [4]: http://www.howtoforge.com/virtualization-with-kvm-on-a-fedora-17-server
 [5]: https://bugzilla.redhat.com/show_bug.cgi?id=839287
