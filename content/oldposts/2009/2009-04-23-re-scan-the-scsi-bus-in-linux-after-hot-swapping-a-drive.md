---
title: Re-scan the SCSI bus in Linux after hot-swapping a drive
author: Major Hayden
date: 2009-04-23T17:00:54+00:00
url: /2009/04/23/re-scan-the-scsi-bus-in-linux-after-hot-swapping-a-drive/
dsq_thread_id:
  - 3642805583
tags:
  - emergency
  - hard disk
  - scsi

---
Servers with hot swappable drive bays are always handy. However, things can turn ugly if the SCSI controller doesn't like a new drive when it is inserted. You may end up with these errors in your dmesg output:

<pre lang="html">kernel: sdb : READ CAPACITY failed.
kernel: sdb : status=0, message=00, host=4, driver=00
kernel: sdb : sense not available.
kernel: sdb: Write Protect is off
kernel: sdb: Mode Sense: 00 00 00 00
kernel: sdb: asking for cache data failed
kernel: sdb: assuming drive cache: write through
kernel:  sdb:&lt;6>sd 1:0:0:0: SCSI error: return code = 0x00040000
kernel: end_request: I/O error, dev sdb, sector 0
kernel: Buffer I/O error on device sdb, logical block 0
kernel: sd 1:0:0:0: SCSI error: return code = 0x00040000
kernel: end_request: I/O error, dev sdb, sector 0
kernel: Buffer I/O error on device sdb, logical block 0
kernel: sd 1:0:0:0: SCSI error: return code = 0x00040000
kernel: end_request: I/O error, dev sdb, sector 0</pre>

The errors show that the SCSI bus is having issues bringing the new drive online, and it won't be seen by the OS until the SCSI controller is pleased. You can force the controller to re-scan the drives attached to it, and this should correct the problem:

<pre lang="html">cd /sys/class/scsi_host/hostX
echo "- - - " > scan</pre>

Replace the **X** with the proper controller number of your SCSI controller. If you're not sure which controller is which, try running:

<pre lang="html"># cat /sys/class/scsi_host/host0/proc_name
sata_nv</pre>

_Credit for this find goes to Tony Dolan_
