---
title: Monitor CyberPower UPS wattage
author: Major Hayden
type: post
date: "2019-11-08"
slug: monitor-cyberpower-ups-wattage
twitter:
  card: "summary_large_image"
  site: "@majorhayden"
  title: Monitor CyberPower UPS wattage
  description: >-
    Monitor the power consumption of your CyberPower UPS and display the live
    output in your Linux desktop's status bar.
  image: images/2019-11-08-cyberpower-ups.png
categories:
  - Blog Posts
tags:
  - chromium
  - fedora
  - linux
---

![ups]

I have a CyberPower [CP1350AVRLCD] under my desk at home and I use it to run my
computer, monitors, speakers, and a lamp. My new computer is a little more
power hungry than my old one since I just moved to to a Ryzen 3700x and Nvidia
GeForce 2060 and I like to keep tabs on how much energy it is consuming.

Some power supplies offer a monitoring interface where you can watch your
power consumption in real time, but I'm not willing to spend that much money.
Most CyberPower UPS units offer some pretty decent power monitoring features
right out of the box, and fortunately for us, they work quite well in Linux.

In this post, we will set up the Linux communication with the UPS and make it
easy to monitor via scripts. Also, we will add it to an existing [polybar]
configuration so we can monitor it right from the desktop environment.

## Installing powerpanel

CyberPower offers software called [PowerPanel] that runs on most Linux
distributions. It has a daemon (`pwrstatd`) and a client (`pwrstat`) that
allows you to monitor the UPS and take actions automatically when the power is
disrupted.

Download the PowerPanel RPM and install it:

```text
sudo dnf install ~/Downloads/powerpanel-132-0x86_64.rpm
```

As I noted in my post called [Troubleshooting CyberPower PowerPanel issues in
Linux], we need to tell `pwrstatd` where it should communicate with the UPS.
If you skip this step, the daemon hangs without much explanation of what is
happening.

Open `/etc/pwrstatd.conf` with your favorite text editor and change the
`allowed_device_nodes` line to point to the right USB device:

```ini
# For example: restrict to use libusb device.
# allowed-device-nodes = libusb
allowed-device-nodes = /dev/usb/hiddev0
```

Unfortunately, CyberPower doesn't ship a systemd unit file for `pwrstatd`.
Write this unit file to `/etc/systemd/system/pwrstatd.service`:

```ini
[Unit]
Description=pwrstatd

[Service]
Group=wheel
UMask=0002
ExecStart=/usr/sbin/pwrstatd

[Install]
WantedBy=multi-user.target
```

The `wheel` group should be fine here if your user is already in that group
and uses sudo. You can also change that to a different group, like `power`,
and then add your user to the `power` group.

Now we can reload systemd, start `pwrstatd`, and ensure it comes up at boot
time:

```text
systemctl daemon-reload
systemctl enable --now pwrstatd
```

## Testing the client

The `pwrstat` client is installed in `/usr/sbin` by default, but since this is
my home computer and I trust what happens there, I want to be able to run this
command as my regular user. Move the client to `/usr/bin` instead:

```text
mv /usr/sbin/pwrstat /usr/bin/pwrstat
```

Let's try getting a current status:

```text
$ pwrstat -status
The UPS information shows as following:

  Properties:
    Model Name...................  CP 1350C
    Firmware Number.............. BFE5107.B23
    Rating Voltage............... 120 V
    Rating Power................. 810 Watt

  Current UPS status:
    State........................ Normal
    Power Supply by.............. Utility Power
    Utility Voltage.............. 124 V
    Output Voltage............... 124 V
    Battery Capacity............. 100 %
    Remaining Runtime............ 38 min.
    Load......................... 137 Watt(17 %)
    Line Interaction............. None
    Test Result.................. Unknown
    Last Power Event............. None
```

## Just the wattage, please

Awesome! Let's make a really short script that will dump just the wattage for
us:

```bash
#!/bin/bash
pwrstat -status | grep -oP "Load\.* \K([0-9]+)(?= Watt)"
```

Now we can test the script:

```text
$ ~/bin/ups_wattage.sh
137
```

My computer (and accessories) are using 137 watts.

## Adding it to polybar

I use polybar as my status bar, and it's easy to add a custom command to the
bar. Here's my configuration section for my `ups_wattage.sh` script:

```ini
[module/wattage]
    type = custom/script
    exec = ~/bin/ups_wattage.sh
    label = " %output%W"
    interval = 15
    format-padding = 1
```

Add that to your bar (mine is on the right side):

```ini
[bar/primary]
    ---SNIP---
    modules-right = weather cpu memory gpu filesystem wattage uptime
    ---SNIP---
```

There's live power monitoring right there in my polybar!

![polybar wattage]

[ups]: /images/2019-11-08-cyberpower-ups.png
[CP1350AVRLCD]: https://www.cyberpowersystems.com/product/ups/intelligent-lcd/cp1350avrlcd/
[polybar]: https://github.com/polybar/polybar
[PowerPanel]: https://www.cyberpowersystems.com/products/software/power-panel-personal/
[Troubleshooting CyberPower PowerPanel issues in Linux]: /2017/07/25/troubleshooting-cyberpower-powerpanel-issues-in-linux/
[polybar wattage]: /images/2019-11-08-polybar-wattage.jpg
