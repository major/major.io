---
aliases:
- /2017/07/25/troubleshooting-cyberpower-powerpanel-issues-in-linux/
author: Major Hayden
date: 2017-07-25 18:16:11
tags:
- cyberpower
- fedora
- linux
- serial
- ups
- usb
title: Troubleshooting CyberPower PowerPanel issues in Linux
---

I have a [CyberPower BRG1350AVRLCD][2] at home and I've just connected it to a new device. However, the `pwrstat` command doesn't retrieve any useful data on the new system:

```
# pwrstat -status

The UPS information shows as following:


    Current UPS status:
        State........................ Normal
        Power Supply by.............. Utility Power
        Last Power Event............. None
```


I disconnected the USB cable and ran `pwrstat` again. **Same output.** I disconnected power from the UPS itself and ran `pwrstat` again. **Same output.** This can't be right.

## Checking the basics

A quick look at `dmesg` output shows that the UPS is connected and the kernel recognizes it:

```
[   65.661489] usb 3-1: new full-speed USB device number 7 using xhci_hcd
[   65.830769] usb 3-1: New USB device found, idVendor=0764, idProduct=0501
[   65.830771] usb 3-1: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[   65.830772] usb 3-1: Product: BRG1350AVRLCD
[   65.830773] usb 3-1: Manufacturer: CPS
[   65.830773] usb 3-1: SerialNumber: xxxxxxxxx
[   65.837801] hid-generic 0003:0764:0501.0004: hiddev0,hidraw0: USB HID v1.10 Device [CPS BRG1350AVRLCD] on usb-0000:00:14.0-1/input0
```


I checked the `/var/log/pwrstatd.log` file to see if there were any errors:

```
2017/07/25 12:01:17 PM  Daemon startups.
2017/07/25 12:01:24 PM  Communication is established.
2017/07/25 12:01:27 PM  Low Battery capacity is restored.
2017/07/25 12:05:19 PM  Daemon stops its service.
2017/07/25 12:05:19 PM  Daemon startups.
2017/07/25 12:05:19 PM  Communication is established.
2017/07/25 12:05:22 PM  Low Battery capacity is restored.
2017/07/25 12:06:27 PM  Daemon stops its service.
```


The `pwrstatd` daemon can see the device and communicate with it. This is unusual.

## Digging into the daemon

If the daemon can truly see the UPS, then what is it talking to? I used `lsof` to examine what the `pwrstatd` daemon is doing:

```
# lsof -p 3975
COMMAND   PID USER   FD   TYPE             DEVICE SIZE/OFF      NODE NAME
pwrstatd 3975 root  cwd    DIR               8,68      224        96 /
pwrstatd 3975 root  rtd    DIR               8,68      224        96 /
pwrstatd 3975 root  txt    REG               8,68   224175 134439879 /usr/sbin/pwrstatd
pwrstatd 3975 root  mem    REG               8,68  2163104 134218946 /usr/lib64/libc-2.25.so
pwrstatd 3975 root  mem    REG               8,68  1226368 134218952 /usr/lib64/libm-2.25.so
pwrstatd 3975 root  mem    REG               8,68    19496 134218950 /usr/lib64/libdl-2.25.so
pwrstatd 3975 root  mem    REG               8,68   187552 134218939 /usr/lib64/ld-2.25.so
pwrstatd 3975 root    0r   CHR                1,3      0t0      1028 /dev/null
pwrstatd 3975 root    1u  unix 0xffff9e395e137400      0t0     37320 type=STREAM
pwrstatd 3975 root    2u  unix 0xffff9e395e137400      0t0     37320 type=STREAM
pwrstatd 3975 root    3u  unix 0xffff9e392f0c0c00      0t0     39485 /var/pwrstatd.ipc type=STREAM
pwrstatd 3975 root    4u   CHR             180,96      0t0     50282 /dev/ttyS1
```


**Wait a minute.** The last line of the `lsof` output shows that `pwrstatd` is talking to `/dev/ttyS1`, but the device is supposed to be a `hiddev` device over USB. If you remember, we had this line in `dmesg` when the UPS was plugged in:

```
hid-generic 0003:0764:0501.0004: hiddev0,hidraw0: USB HID v1.10 Device [CPS BRG1350AVRLCD] on usb-0000:00:14.0-1/input0
```


Things are beginning to make more sense now. I have a USB-to-serial device that allows my server to talk to the console port on my Cisco switch:

```
[   80.389533] usb 3-1: new full-speed USB device number 9 using xhci_hcd
[   80.558025] usb 3-1: New USB device found, idVendor=067b, idProduct=2303
[   80.558027] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   80.558028] usb 3-1: Product: USB-Serial Controller D
[   80.558029] usb 3-1: Manufacturer: Prolific Technology Inc.
[   80.558308] pl2303 3-1:1.0: pl2303 converter detected
[   80.559937] usb 3-1: pl2303 converter now attached to ttyUSB0
```


It appears that `pwrstatd` is trying to talk to my Cisco switch (through the USB-to-serial adapter) rather than my UPS! I'm sure they could have a great conversation together, but it's hardly productive.

## Fixing it

The `/etc/pwrstatd.conf` has a relevant section:

```ini
# The pwrstatd accepts four types of device node which includes the 'ttyS',
# 'ttyUSB', 'hiddev', and 'libusb' for communication with UPS. The pwrstatd
# defaults to enumerate all acceptable device nodes and pick up to use an
# available device node automatically. But this may cause a disturbance to the
# device node which is occupied by other software. Therefore, you can restrict
# this enumerate behave by using allowed-device-nodes option. You can assign
# the single device node path or multiple device node paths divided by a
# semicolon at this option. All groups of 'ttyS', 'ttyUSB', 'hiddev', or
# 'libusb' device node are enumerated without a suffix number assignment.
# Note, the 'libusb' does not support suffix number only.
#
# For example: restrict to use ttyS1, ttyS2 and hiddev1 device nodes at /dev
# path only.
# allowed-device-nodes = /dev/ttyS1;/dev/ttyS2;/dev/hiddev1
#
# For example: restrict to use ttyS and ttyUSB two groups of device node at
# /dev,/dev/usb, and /dev/usb/hid paths(includes ttyS0 to ttySN and ttyUSB0 to
# ttyUSBN, N is number).
# allowed-device-nodes = ttyS;ttyUSB
#
# For example: restrict to use hiddev group of device node at /dev,/dev/usb,
# and /dev/usb/hid paths(includes hiddev0 to hiddevN, N is number).
# allowed-device-nodes = hiddev
#
# For example: restrict to use libusb device.
# allowed-device-nodes = libusb
allowed-device-nodes =
```


We need to explicitly tell `pwrstatd` to talk to the UPS on `/dev/hid/hiddev0`:

```
allowed-device-nodes = /dev/usb/hiddev0
```


Let's restart the `pwrstatd` daemon and see what we get:

```
# systemctl restart pwrstatd
# pwrstat -status

The UPS information shows as following:

    Properties:
        Model Name................... BRG1350AVRLCD
        Firmware Number..............
        Rating Voltage............... 120 V
        Rating Power................. 810 Watt(1350 VA)

    Current UPS status:
        State........................ Normal
        Power Supply by.............. Utility Power
        Utility Voltage.............. 121 V
        Output Voltage............... 121 V
        Battery Capacity............. 100 %
        Remaining Runtime............ 133 min.
        Load......................... 72 Watt(9 %)
        Line Interaction............. None
        Test Result.................. Unknown
        Last Power Event............. None
```


Success!

_Photo credit: [Wikipedia][3]_

 [1]: /wp-content/uploads/2017/07/1024px-Sierra_Blanca_and_electricity_pole-e1501006440664.jpg
 [2]: https://www.cyberpowersystems.com/product/ups/brg1350avrlcd/
 [3]: https://commons.wikimedia.org/wiki/File%3ASierra_Blanca_and_electricity_pole.jpg