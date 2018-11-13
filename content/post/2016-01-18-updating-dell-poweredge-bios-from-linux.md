---
title: Updating Dell PowerEdge BIOS from Linux
author: Major Hayden
type: post
date: 2016-01-18T20:53:38+00:00
url: /2016/01/18/updating-dell-poweredge-bios-from-linux/
medium_post:
  - 'O:11:"Medium_Post":9:{s:16:"author_image_url";s:68:"https://cdn-images-1.medium.com/fit/c/200/200/0*0oSauxLPsThabN5E.jpg";s:10:"author_url";s:31:"https://medium.com/@majorhayden";s:10:"cross_link";s:3:"yes";s:2:"id";s:12:"6c534896241f";s:21:"follower_notification";s:3:"yes";s:7:"license";s:11:"cc-40-by-sa";s:14:"publication_id";s:2:"-1";s:6:"status";s:6:"public";s:3:"url";s:84:"https://medium.com/@majorhayden/updating-dell-poweredge-bios-from-linux-6c534896241f";}'
dsq_thread_id:
  - 4502784248
categories:
  - Blog Posts
tags:
  - centos
  - dell
  - fedora
  - hardware
  - redhat
  - ubuntu

---
<a href="/wp-content/uploads/2016/01/2466171910_7d18907322_o-e1453148385165.jpg" rel="attachment wp-att-6031"><img src="/wp-content/uploads/2016/01/2466171910_7d18907322_o-e1453148385165.jpg" alt="Dell PowerEdge Server" width="3850" height="999" class="size-full wp-image-6031" srcset="/wp-content/uploads/2016/01/2466171910_7d18907322_o-e1453148385165.jpg 3850w, /wp-content/uploads/2016/01/2466171910_7d18907322_o-e1453148385165-300x78.jpg 300w, /wp-content/uploads/2016/01/2466171910_7d18907322_o-e1453148385165-768x199.jpg 768w, /wp-content/uploads/2016/01/2466171910_7d18907322_o-e1453148385165-1024x266.jpg 1024w" sizes="(max-width: 3850px) 100vw, 3850px" /></a>

Updating Dell PowerEdge firmware from Linux is quite easy, but it isn't documented very well. I ended up with a set of PowerEdge R710's at work for a lab environment and the BIOS versions were different on each server.

## Downloading the latest firmware

Start by heading over to [Dell's support site][1] and enter your system's service tag. You can use `lshw` to find your service tag:

```
# lshw | head
lab05
    description: Rack Mount Chassis
    product: PowerEdge R710 ()
    vendor: Dell Inc.
    serial: [service tag should be here]
    width: 64 bits
    capabilities: smbios-2.6 dmi-2.6 vsyscall32
    configuration: boot=normal chassis=rackmount uuid=44454C4C-3700-104A-8052-B2C04F564831
  *-core
       description: Motherboard
```


After entering the service tag, follow these steps:

  * Click **Drivers & downloads** on the left
  * Click **Change OS** at the top right and choose **Red Hat Enterprise Linux 7**
  * Click the **BIOS** dropdown in the list
  * Click **Other file formats available**
  * Look for the file ending in **BIN** and click **Download file** underneath it

Copy that file to your server that needs a BIOS update.

## Installing firmware update tools

Start by getting the right packages installed. I'll cover the CentOS/RHEL and Ubuntu methods here. At the moment, Fedora doesn't build kernels with the `dell_rbu` module enabled, but there's a [discussion about getting that fixed][2].

For CentOS, you'll need to get the Dell Linux repository configured first:

```
wget http://linux.dell.com/repo/hardware/latest/bootstrap.cgi
sh bootstrap.cgi
yum -y install firmware-addon-dell
```


For Ubuntu, the package is in the upstream repositories already:

```
apt-get -y install firmware-addon-dell
```


## Extract and flash the BIOS header

Dell packages up a BIOS header (the actual firmware blob that needs to be flashed) within the BIN file you downloaded earlier. The latest version of the BIOS for my R710 is 6.4.0, so my file is called `R710_BIOS_4HKX2_LN_6.4.0.BIN`. Let's start by extracting the header file:

```
bash R710_BIOS_4HKX2_LN_6.4.0.BIN --extract bios
```


You should now have a directory in your current directory called `bios`. The header file is within `bios/payload/` and you'll use that to flash the BIOS:

```
# modprobe dell_rbu
# dellBiosUpdate-compat --hdr bios/payload/R710-060400.hdr --update
Supported RBU type for this system: (MONOLITHIC, PACKET)
Using RBU v2 driver. Initializing Driver.
Setting RBU type in v2 driver to: PACKET
writing (4096) to file: /sys/devices/platform/dell_rbu/packet_size
Writing RBU data (4096bytes/dot): ...........................
Done writing packet data.
Activate CMOS bit to notify BIOS that update is ready on next boot.
Update staged sucessfully. BIOS update will occur on next reboot.
```


It's now time to reboot! If you watch the console via iDRAC, you'll see a 3-4 minute delay on the next reboot while the staged BIOS image is flashed. When the server boots, use `lshw` to verify that the BIOS version has been updated.

_Photo Credit: [vaxomatic][3] via [Compfight][4] [cc][5]_

 [1]: http://support.dell.com/
 [2]: https://lists.fedoraproject.org/archives/list/kernel@lists.fedoraproject.org/thread/L623WBK7HAAQWD5FG2MFBD7SIGNGXXVJ/
 [3]: https://www.flickr.com/photos/21881956@N05/2466171910/
 [4]: http://compfight.com
 [5]: https://creativecommons.org/licenses/by/2.0/
