---
aliases:
- /2009/01/26/linux-adjust-storage-kernel-module-load-order/
author: Major Hayden
date: 2009-01-26 20:40:01
dsq_thread_id:
- 3642805511
tags:
- drivers
- kernel
- linux
- ubuntu
title: 'Linux: Adjust storage kernel module load order'
---

I set up a system at home that has two SATA controllers: one is on the motherboard (nvidia chipset), while the other is on a Silicon Image SATA card that has three eSATA ports. Here is the relevant `lspci` output:

<pre>root@storageserver:~# lspci | grep ATA
00:08.0 IDE interface: nVidia Corporation MCP61 SATA Controller (rev a2)
00:08.1 IDE interface: nVidia Corporation MCP61 SATA Controller (rev a2)
03:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)</pre>

There are two primary drives connected to the onboard controller and four connected to the controller card. One of the primary drives on the onboard controller contains the operating system (Ubuntu, in this case), while the other drive is blank.

When the system booted, the sata\_sil24 driver for the add-on card always loaded before the sata\_nv drivers for the onboard storage controller:

<pre>kernel: [    4.125598] sata_sil24 0000:03:00.0: version 1.1
kernel: [    4.126102] sata_sil24 0000:03:00.0: PCI INT A -> Link[APC6] -> GSI 16 (level, low) -> IRQ 16
kernel: [    4.126161] sata_sil24 0000:03:00.0: setting latency timer to 64
kernel: [    4.129472] scsi0 : sata_sil24
kernel: [    4.129635] scsi1 : sata_sil24
kernel: [    8.293762] sata_nv 0000:00:08.0: version 3.5
kernel: [    8.293779] sata_nv 0000:00:08.0: PCI INT A -> Link[APSI] -> GSI 20 (level, low) -> IRQ 20
kernel: [    8.293829] sata_nv 0000:00:08.0: setting latency timer to 64
kernel: [    8.296764] scsi2 : sata_nv
kernel: [    8.296905] scsi3 : sata_nv
kernel: [    9.285034] sata_nv 0000:00:08.1: PCI INT B -> Link[APSJ] -> GSI 21 (level, low) -> IRQ 21
kernel: [    9.285074] sata_nv 0000:00:08.1: setting latency timer to 64
kernel: [    9.285161] scsi4 : sata_nv
kernel: [    9.286015] scsi5 : sata_nv</pre>

After specifying an explicit order in /etc/modules and /etc/modprobe.conf, I wasn't able to see any changes. The sata\_sil24 driver still loaded before the onboard sata\_nv driver. Luckily, a [very wise person][1] on [Twitter][2] [gave me a strategy][3] that [worked just fine][4].

I added sata\_sil24 to the bottom of my /etc/modprobe.d/blacklist file first. Then, in /etc/modules, I listed sata\_nv first, followed by sata_sil24. When the system booted, I got the result that I wanted:

<pre>kernel: [    3.982909] sata_nv 0000:00:08.0: version 3.5
kernel: [    3.982931] sata_nv 0000:00:08.0: PCI INT A -> Link[APSI] -> GSI 20 (level, low) -> IRQ 20
kernel: [    3.982993] sata_nv 0000:00:08.0: setting latency timer to 64
kernel: [    3.984497] scsi0 : sata_nv
kernel: [    3.986013] scsi1 : sata_nv
kernel: [    4.971755] sata_nv 0000:00:08.1: PCI INT B -> Link[APSJ] -> GSI 21 (level, low) -> IRQ 21
kernel: [    4.971799] sata_nv 0000:00:08.1: setting latency timer to 64
kernel: [    4.973153] scsi2 : sata_nv
kernel: [    4.974031] scsi3 : sata_nv
kernel: [   15.988862] sata_sil24 0000:03:00.0: version 1.1
kernel: [   15.989454] sata_sil24 0000:03:00.0: PCI INT A -> Link[APC6] -> GSI 16 (level, low) -> IRQ 16
kernel: [   15.989511] sata_sil24 0000:03:00.0: setting latency timer to 64
kernel: [   15.990201] scsi6 : sata_sil24
kernel: [   15.991523] scsi7 : sata_sil24</pre>

The sata\_nv driver is loading first, and Ubuntu boots off of it without an issue. The sata\_sil24 driver loads next so that the drives connected to the card show up lower in the boot order.

_Many thanks to [@Twirrim][1] on Twitter for the suggestion!_

 [1]: http://twitter.com/Twirrim
 [2]: http://twitter.com/
 [3]: http://twitter.com/Twirrim/status/1148330615
 [4]: http://tinyurl.com/d53f6e