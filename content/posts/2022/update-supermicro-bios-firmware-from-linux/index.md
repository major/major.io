---
author: Major Hayden
categories:
  - Blog Posts
date: '2022-04-07'
description: >-
  Upgrade your Supermicro BIOS firmware from Linux using their SUM utility. 🔧
cover:
  image: cover.jpg
  alt: >-
    Corner view of a building with a covered porch on top
  caption: >-
    Photo credit: [Étienne Beauregard-Riverin](https://unsplash.com/photos/B0aCvAVSX8E)
  relative: true
slug: update-supermicro-bios-firmware-from-linux
tags:
  - fedora
  - hardware
  - linux
  - supermicro
  - terminal
title: Update Supermicro BIOS firmware from Linux
type: post
---

The [Linux Vendor Firmware Service] (LVFS) and [fwupd] turned the troublesome and time
consiming activities of updating all kinds of firmware for laptops, desktops, and
servers into something much easier. Check your list of updated firmware, update it, and
submit feedback for the vendors when something doesn't work. You can even get
notifications right inside GUI applications, such as GNOME Software, that notify you
about updates and allow you to install them with one click.

However, not all vendors participate in LVFS and some vendors only participate in LVFS
for some devices. I've had a [small Supermicro server] at home that's been offline for
quite some time. I decided to get it back online for some new projects and I discovered
that the BIOS and BMC firmware were both extremely old.

This device isn't included in LVFS, so we're stuck with older methods.

[Linux Vendor Firmware Service]: https://fwupd.org/
[fwupd]: https://github.com/fwupd/fwupd
[small Supermicro server]: /2015/09/28/first-thoughts-linux-on-the-supermicro-5028d-t4nt/

## Update the BMC

The [baseband management controller], or BMC, is an always-running component that
provides out-of-band access to my server. I can control the server's power, view a
virtrual console, or control certain BIOS configurations from a web browser or IPMI
client.

Luckily, Supermicro makes it easy to update the BMC directly from the web interface. Our
first step is to identify which board is inside the machine:

```console
$ sudo dmidecode -t 2
# dmidecode 3.3
Getting SMBIOS data from sysfs.
SMBIOS 2.8 present.

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: Supermicro
	Product Name: X10SDV-TLN4F
	Version: 1.02
	Serial Number: xxxxxxxxxxxx
	Asset Tag: To be filled by O.E.M.
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: To be filled by O.E.M.
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0
```

Asking `dmidecode` for type 2 DMI data should give you the motherboard model in the
`Product Name` field. In this case, mine is `X10SDV-TLN4F`. I ran over to [Supermicro's
BMC List], typed in the motherboard model number, and downloaded the zip file. After
unpacking the zip, I had a bunch of items:

```
$ unzip -q REDFISH_X10_388_20200221_unsigned.zip
$ ls *.bin
REDFISH_X10_388_20200221_unsigned.bin
```

This `REDFISH_X10_388_20200221_unsigned.bin` contains the firmware update for the BMC.
Now access your IPMI interface via a web browser and authenticate. Follow these steps:

* Click the **Maintenance** menu and select **Firmware Update**
* Click **Enter Update Mode**
* Select your `.bin` file and update the BMC

The upload process took around a minute and the BMC update took four or five minutes.
The BMC will respond to pings early after the update but it will take a while for the
web interface to respond. Be patient!

[baseband management controller]: https://en.wikipedia.org/wiki/Intelligent_Platform_Management_Interface#Baseboard_management_controller
[Supermicro's BMC List]: https://www.supermicro.com/support/resources/bios_ipmi.php?type=BMC

## Update the BIOS

If you have the appropriate license for your BMC, you can update the BIOS right from the
BMC interface. I don't have that license. Let's find another way!

Start by downloading Supermicro's [SUM utility]. The software is available after the
registration step (which is free). In my case, I needed the second download (not the
UEFI one) since my server is a little older.

Now we need to download the BIOS firmware itself. One of the easiest methods I've seen
for this is to throw `supermicro X10SDV-TLN4F` (replace with your motherboard model)
into Google and click the result. Then look for a **Update your BIOS** link under
**Links & Resources** on the right side. That takes you directly to a zip file to
download.

Create a directory (perhaps `bios`) and move the SUM zip as well as your firmware zip
file in that directory. Some of these zip files have no directory prefix included and
they will clobber your working directory. 🤦🏻‍♂️

Unpack both zip files and find the `sum` executable:

```console
$ find . -name sum
./sum_2.8.0_Linux_x86_64/sum
```

Great! Now we need to find the BIOS firmware file. In most cases, they start with a few
characters from your motherboard and end in a numerical extension:

```console
$ ls -1
AFUDOSU.smc
BIOS_X10SDV-TLNF_20210604_2.3_STDsp.zip
CHOICE.SMC
FDT.smc
FLASH.BAT
'Readme for AMI BIOS.txt'
sum_2.8.0_Linux_x86_64
sum_2.8.0_Linux_x86_64_20220126.tar.gz
X10SDVF1.604
```

The BIOS firmware is inside `X10SDVF1.604` in my case. But first:

> 💣 **UPGRADING BIOS FIRMWARE IS SERIOUS BUSINESS.** 😱 If an upgrade goes wrong, it
> may be challenging to get the system running properly again. I've recovered from some
> pretty awful BIOS update failures in the past on most x86 systems, but it was rarely
> an enjoyable process. Be sure you have **stable power for the device**, you are
> running the update **inside tmux** (especially if connected via ssh), and you **have
> time** to complete the operation.
>
> You have been warned! 👀

🚨 Start with a `tmux` or `screen` session, always. Seriously. Don't skip this step.

Inside the `tmux` or `screen` session _(which I'm sure you started because you were
paying attention)_, let's update the firmware:

```console
$ sudo ./sum -c UpdateBios --file /home/major/bios/X10SDVF1.604
Supermicro Update Manager (for UEFI BIOS) 2.8.0 (2022/01/26) (x86_64)
Copyright(C) 2013-2022 Super Micro Computer, Inc. All rights reserved.

WARNING: BIOS setting will be reset without option --preserve_setting
Reading BIOS flash ..................... (100%)
Writing BIOS flash ..................... (100%)
Verifying BIOS flash ................... (100%)
Checking ME Firmware ...
Putting ME data to BIOS ................ (100%)
Writing ME region in BIOS flash ...
 - FDT won't be updated when ME is not in Manufacturing mode!!
   BIOS upgrade continues...
 - Updated Recovery Loader to OPRx
 - Updated FPT, MFSB, FTPR and MFS
 - ME Entire Image done
WARNING:Must power cycle or restart the system for the changes to take effect!
```

Awesome! My preference here is to power down, wait a few seconds, and power it back up.
I've had issues in the past with soft restarts after BIOS upgrades on non-laptop systems
and I'm ultra cautious.

```console
$ sudo poweroff
```

Once it's fully powered down, power it back up using the BMC/IPMI or via the button on
the device. If all goes well, you should see a new firmware version after boot:

```console
$ sudo dmidecode -t 0
# dmidecode 3.3
Getting SMBIOS data from sysfs.
SMBIOS 2.8 present.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: 2.3
	Release Date: 06/04/2021
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 16 MB
```

Perfect! 🎉 I downloaded version 2.3 from Supermicro's site and it's now running on my
server!

## Extra credit

You may want to do some additional (optional) steps depending on your configuration.

I rebooted into the BIOS and chose to load the optimized defaults in case something
important was changed in the latest BIOS firmware. This may revert a few of your
settings if you had some customizations, so be sure to roll through the BIOS menu and
look for any of those issues.

[SUM utility]: https://www.supermicro.com/SwDownload/UserInfo.aspx?sw=0&cat=SUM
