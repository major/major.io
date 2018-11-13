---
title: PXE boot Fedora 19 using a Mikrotik firewall
author: Major Hayden
type: post
date: 2013-07-23T21:47:33+00:00
url: /2013/07/23/pxe-boot-fedora-19-using-a-mikrotik-firewall/
dsq_thread_id:
  - 3642807335
categories:
  - Blog Posts
tags:
  - fedora
  - mikro
  - network
  - pxe
  - redhat
  - ssh
  - sysadmin
  - virt-manager
  - virtualization

---
Outside of the RHCA exams, I haven't configured a [PXE][1] system for my personal needs. A colleague demoed his PXE setup for me and I was hooked. Once I realized how much time I could save when I'm building and tearing down virtual machines, it made complete sense. This post will show you how to configure PXE and tftpd in [Mikrotik's RouterOS][2] to boot and install Fedora 19 (as well as provide rescue environments).

The first thing you'll need are a few files from a working Fedora installation. Install the `syslinux-tftpboot` package and grab the following files:

```
/tftpboot/pxelinux.0
/tftpboot/vesamenu.c32
```


You'll also need a [vmlinuz][3] and [initrd.img][4] file from your favorite Fedora mirror (use the linked text here for F19 x86_64 or look in the `os/images/pxeboot` directory on the mirror for your architecture).

When you have your four files, create a directory on the Mikrotik via FTP called **tftp**, and upload those to your Mikrotik. Your directory should look something like this:

```
 ls tftp/
-rw-rw----   1 root     root       155792 Jul 23 00:01 vesamenu.c32
-rw-rw----   1 root     root      5055896 Jul 22 23:41 vmlinuz
-rw-rw----   1 root     root     32829968 Jul 22 23:42 initrd.img
-rw-rw----   1 root     root        26460 Jul 22 23:37 pxelinux.0
```


Within the **tftp** directory, make a directory called **pxelinux.cfg**. Add a file called **default** inside the pxelinux.cfg directory with these contents:

```
default vesamenu.c32
prompt 0
timeout 600

display boot.msg

label linux
  menu label ^Install or upgrade an existing system
  kernel vmlinuz
  append initrd=initrd.img repo=http://mirrors.kernel.org/fedora/releases/19/Fedora/x86_64/os/ ks=http://example.com/kickstart.ks ip=eth0:dhcp
label vesa
  menu label Install system with ^basic video driver
  kernel vmlinuz
  append initrd=initrd.img xdriver=vesa nomodeset
label rescue
  menu label ^Rescue installed system
  menu default
  kernel vmlinuz
  append initrd=initrd.img repo=http://mirrors.kernel.org/fedora/releases/19/Fedora/x86_64/os/ rescue ip=eth0:dhcp
label local
  menu label Boot from ^local drive
  localboot 0xffff
```


Be sure to adjust the `ip=` `and` `repo=` arguments to fit your server. Keep in mind that from Fedora 17 on, you'll need to use the [dracut syntax][5] for anaconda boot options. Once that's done, you're ready to configure the Mikrotik firewall, so get logged into the firewall over ssh.

We need to set some network options for our Mikrotik's DHCP server:

```
/ip dhcp-server network
set 0 boot-file-name=pxelinux.0 next-server=192.168.25.1
```


The value for `next-server=` should be the gateway address for your internal network (the Mikrotik's internal IP).

Next, we need to configure the tftp server so that it serves up files to our internal network:

```
/ip tftp
add ip-addresses=192.168.25.0/24 real-filename=tftp/pxelinux.0 req-filename=pxelinux.0
add ip-addresses=192.168.25.0/24 real-filename=tftp/pxelinux.cfg/default req-filename=pxelinux.cfg/default
add ip-addresses=192.168.25.0/24 real-filename=tftp/vmlinuz req-filename=vmlinuz
add ip-addresses=192.168.25.0/24 real-filename=tftp/vesamenu.c32 req-filename=vesamenu.c32
add ip-addresses=192.168.25.0/24 real-filename=tftp/initrd.img req-filename=initrd.img
```


Now it's time to test it! If you're using a physical machine, double check your BIOS to verify that PXE boot is enabled for your ethernet interface. Most modern chipsets have support for it, but be sure to check that it's enabled. You may have to reboot after enabling it in the BIOS for the ethernet BIOS to be included.

If you're using a virtual machine, just start up virt-manager and choose _Network Boot (PXE)_ from the installation options:

[<img src="http://major.io/wp-content/uploads/2013/07/virt-manager-pxe.png" alt="Install virtual machines with PXE using virt-manager" width="436" height="411" class="aligncenter size-full wp-image-4522" />][6]

Once the VM boots, you'll be sent straight to the PXE boot screen:

[<img src="http://major.io/wp-content/uploads/2013/07/pxetest-Virtual-Machine.png" alt="pxetest Virtual Machine" width="812" height="642" class="aligncenter size-full wp-image-4525" />][7]

**TAKE NOTE!** In the pxelinux.cfg/default file, I set rescue mode to boot as the default option. This will prevent a situation where you forget to remove PXE from a system's boot order and accidentally re-kickstart over the live system.

The installer should now boot up normally and you can install your Fedora system via kickstart or via the anaconda interface.

 [1]: http://en.wikipedia.org/wiki/Preboot_Execution_Environment
 [2]: http://major.io/?s=mikrotik
 [3]: http://mirrors.kernel.org/fedora/releases/19/Fedora/x86_64/os/images/pxeboot/vmlinuz
 [4]: http://mirrors.kernel.org/fedora/releases/19/Fedora/x86_64/os/images/pxeboot/initrd.img
 [5]: https://fedoraproject.org/wiki/Dracut/Options#Network
 [6]: http://major.io/wp-content/uploads/2013/07/virt-manager-pxe.png
 [7]: http://major.io/wp-content/uploads/2013/07/pxetest-Virtual-Machine.png
