---
author: Major Hayden
date: '2019-12-12'
summary: My new T490 with a 10th generation Intel CPU and a discrete NVIDIA MX250
  has arrived! Installing Linux creates some interesting challenges.
images:
- images/20191212-t490.png
slug: thinkpad-t490-fedora-install-tips
tags:
- fedora
- lenovo
- linux
- thinkpad
title: Thinkpad T490 Fedora install tips
---

> 🔨 **WORK IN PROGRESS!** I'm still finding some additional issues and I'll
> write those up here as soon as I find some solutions.

{{< figure src="/images/20191212-t490.png" title="Thinkpad T490" >}}

With my 4th Gen X1 Carbon beginning to age (especially the battery), it was
time for an upgrade. I now have a T490 with a 10th gen Intel CPU and a
discrete NVIDIA MX250 GPU. This laptop spec was just released on Black Friday!

As with any new technology, there are bound to be some quirks in Linux that
require some workarounds. This laptop is no exception!

This post will grow over time as I find more workarounds and fixes for this
laptop.

## Installing Fedora

Start by downloading whichever installation method of Fedora you prefer. Since
this laptop is fairly new, I went with the network installation (included in
the Server ISOs) and chose to apply updates during installation.

On the first boot, wait for the LUKS screen to appear and ask for your
password to decrypt the drive. Hit `CTRL-ALT-DEL` at the password prompt
and wait for the grub screen to appear on reboot.

> **Why are we issuing the three finger salute?** If you allow the laptop to
> fully boot, it will hang when it starts gdm. There are some nouveau issues
> in the system journal that provide hints but I haven't made sense of them
> yet. By preventing the system from fully booting, the grub success flag
> won't be set and you will see the grub menu at the next boot that is
> normally hidden from you.

Press `e` on the first line of the grub menu. Find the longest line (it
usually has `rhgb quiet`) and add this text to the end:

```text
rd.driver.blacklist=nouveau
```

Press `CTRL-X` to boot the system. Enter your LUKS password when asked and you
should boot straight into gdm!

You have two options here:

* **Blacklist nouveau until bugs are fixed.** *(Not recommended)* This will
  force your laptop to use the integrated Intel GPU on the CPU, but it may or
  may not shut off the NVIDIA GPU. This could cause a significant battery
  drain.

* **Install NVIDIA's proprietary drivers.** *(Recommended)* You will have much
  better control over the power state of the NVIDIA GPU and the installation
  process will automatically blacklist nouveau for you.

I'm going to install NVIDIA's proprietary drivers that have power management
and optimus support built in already. All of these steps here come from [RPM
Fusion's excellent NVIDIA documentation].

Start by installing RPMFusion's repository configuration:

```text
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

Next, install the proprietary drivers.

```text
sudo dnf install akmod-nvidia
```

When the packages are installed, run `akmods` to build the `nvidia` kernel
module (this took about a minute on my laptop):

```text
# sudo akmods
Checking kmods exist for 5.3.15-300.fc31.x86_64            [  OK  ]
```

Reboot your laptop. If all goes well, your laptop should boot right up without
interaction (except for entering your LUKS password).

[Server ISOs]: http://mirrors.kernel.org/fedora/releases/31/Server/x86_64/iso/
[RPM Fusion's excellent NVIDIA documentation]: https://rpmfusion.org/Howto/NVIDIA

## NVIDIA power management

You can enable some power management features for the NVIDIA GPU by following
the (somewhat lengthy) documentation about [PCI-Express Runtime D3 (RTD3)
Power Management]. I've enabled the most aggressive setting by adding the
following to `/etc/modprobe.d/nvidia.conf`:

```text
options nvidia "NVreg_DynamicPowerManagement=0x02"
```

Reboot your laptop for the change to take effect.

[PCI-Express Runtime D3 (RTD3) Power Management]: http://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/dynamicpowermanagement.html

## BIOS Updates

My laptop was shipped to me with the 1.04 BIOS, but 1.06 is the latest (as of
this writing). Follow these steps to update:

* Open the *Software* application
* Go to the *Updates* tab
* Look for a firmware update (usually at the end of the list)
* Click update and wait for a notification
* Reboot

The firmware capsule is found on the first reboot and then the laptop reboots
to install the new firmware. You'll see some screens about backing up the BIOS
and some self-health related things. They take a while to complete, but my
laptop came right up on 1.06 without any problems!
