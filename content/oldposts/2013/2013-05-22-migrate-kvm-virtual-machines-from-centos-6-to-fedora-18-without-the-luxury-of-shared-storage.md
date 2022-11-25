---
title: Migrate KVM virtual machines from CentOS 6 to Fedora 18 without the luxury of shared storage
author: Major Hayden
date: 2013-05-22T15:15:36+00:00
url: /2013/05/22/migrate-kvm-virtual-machines-from-centos-6-to-fedora-18-without-the-luxury-of-shared-storage/
dsq_thread_id:
  - 3642807287
tags:
  - centos
  - command line
  - fedora
  - kvm
  - linux
  - red hat
  - virtualization

---
I've converted one of my KVM hypervisors from CentOS 6 to Fedora 18 and now comes the task of migrating my virtual machines off of my single remaining CentOS 6 hypervisor. This is definitely on a budget, so there's no shared storage to make this process easier.

Here's how I did it:

**Migrate the logical volume**

My first VM to migrate is my Fedora development VM where I build and test new packages. I have a 10G logical volume on the old node:

```
[root@helium ~]# lvs /dev/mapper/vg_helium-fedora--dev
  LV         VG        Attr     LSize  Pool Origin Data%  Move Log Copy%  Convert
  fedora-dev vg_helium -wi-a--- 10.00g
```

I made a 10G logical volume on the new hypervisor:

```
[root@hydrogen ~]# lvcreate -n fedora-dev -L10G vg_hydrogen
  Logical volume "fedora-dev" created
```

After getting ssh keys set up between both hypervisors and installing [`pv`][1] (to track progress), I started the storage migration over ssh:

```
dd if=/dev/mapper/vg_helium-fedora--dev | pv | ssh hydrogen dd of=/dev/mapper/vg_hydrogen-fedora--dev
```

Luckily it was only a 10GB logical volume so it transferred over in a few minutes.

**Dump and adjust the source VM's XML**

On the source server, I dumped the VM configuration to an XML file and copied it to the new host:

```
virsh dumpxml fedora-dev > fedora-dev.xml
scp fedora-dev.xml hydrogen:
```

Before importing the XML file on the new host, there are some adjustments that need to be made. First off was an adjustment of the storage volume since the new host had the same logical volume name but a different volume group (the source line):

```xml
  <disk type='block' device='disk'>
  <driver name='qemu' type='raw' cache='none' io='native'></driver>
  <source dev='/dev/vg_hydrogen/fedora-dev'/>
  <target dev='vda' bus='virtio'></target>


<address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'>

</address>
</disk>
```

Also, there's a mismatch with the machine type (not architecture) between CentOS 6 and Fedora 18. I dumped the XML from a VM running on the Fedora 18 hypervisor and compared the machine type to my old CentOS VM's XML (the XML from the CentOS VM is on top):

```diff
-    <type arch='x86_64' machine='rhel6.3.0'>hvm</type>
+    <type arch='x86_64' machine='pc-1.2'>hvm</type>
```

I replaced `rhel6.3.0` with `pc-1.2`. _If you forget this step, your VM won't start._ You'll get some errors about a mismatched machine type before the VM boots.

There's one last fix: the path to the `qemu-kvm` emulator:

```diff
-    <emulator>/usr/libexec/qemu-kvm</emulator>
+    <emulator>/usr/bin/qemu-kvm</emulator>
```

Replace `/usr/libexec/qemu-kvm` with `/usr/bin/qemu-kvm` and save your XML file.

**Import the VM configuration and launch the VM**

Importing the VM on the Fedora 18 hypervisor was easy:

```
virsh define fedora-dev.xml
```

That causes the configuration to load into libvirt and it should appear in `virt-manager` or `virsh list` by this point. If not, double check your previous steps and look for error messages in your logs. That doesn't actually start the virtual machine, so I started it on the command line:

```
virsh start fedora-dev
```

Within a few moments, the VM was up and responding to pings.

It's a good idea to hop into `virt-manager` and verify that the VM configuration is what you expect. Some configuration options don't line up terribly well between CentOS 6 and Fedora 18. You might need to adjust a few to match the performance you expect to see.

 [1]: http://linux.die.net/man/1/pv
