---
aliases:
- /2015/07/19/restoring-wireless-and-bluetooth-state-after-reboot-in-fedora-22/
author: Major Hayden
date: 2015-07-19 22:14:30
tags:
- bluetooth
- fedora
- network
- networkmanager
- thinkpad
- wireless
title: Restoring wireless and Bluetooth state after reboot in Fedora 22
---

![1]

My upgrade to Fedora 22 on the ThinkPad X1 Carbon was fairly uneventful and the hiccups were minor. One of the more annoying items that I've been struggling with for quite some time is how to boot up with the wireless LAN and Bluetooth disabled by default. Restoring wireless and Bluetooth state between reboots is normally handled quite well in Fedora.

In Fedora 21, NetworkManager saved my settings between reboots. For example, if I shut down with wifi off and Bluetooth on, the laptop would boot up later with wifi off and Bluetooth on. This wasn't working well in Fedora 22: both the wifi and Bluetooth were always enabled by default.

### Digging into rfkill

I remembered [rfkill][2] and began testing out some commands. It detected that I had disabled both devices via NetworkManager (soft):

```
$ rfkill list
0: tpacpi_bluetooth_sw: Bluetooth
    Soft blocked: yes
    Hard blocked: no
2: phy0: Wireless LAN
    Soft blocked: yes
    Hard blocked: no
```


It looked like systemd has some hooks already configured to manage rfkill via the [systemd-rfkill][3] service. However, something strange happened when I tried to start the service:

```
# systemctl start systemd-rfkill@0
Failed to start systemd-rfkill@0.service: Unit systemd-rfkill@0.service is masked.
```


Well, that's certainly weird. While looking into why it's masked, I found an empty file in `/etc/systemd`:

```
# ls -al /etc/systemd/system/systemd-rfkill@.service
-rwxr-xr-x. 1 root root 0 May 11 16:36 /etc/systemd/system/systemd-rfkill@.service
```


I don't remember making that file. Did something else put it there?

```
# rpm -qf /etc/systemd/system/systemd-rfkill@.service
tlp-0.7-4.fc22.noarch
```


Ah, [tlp][4]!

### Configuring tlp

I looked in tlp's configuration file in `/etc/default/tlp` and found a few helpful configuration items:

```
# Restore radio device state (Bluetooth, WiFi, WWAN) from previous shutdown
# on system startup: 0=disable, 1=enable.
# Hint: the parameters DEVICES_TO_DISABLE/ENABLE_ON_STARTUP/SHUTDOWN below
#   are ignored when this is enabled!
RESTORE_DEVICE_STATE_ON_STARTUP=0

# Radio devices to disable on startup: bluetooth, wifi, wwan.
# Separate multiple devices with spaces.
#DEVICES_TO_DISABLE_ON_STARTUP="bluetooth wifi wwan"

# Radio devices to enable on startup: bluetooth, wifi, wwan.
# Separate multiple devices with spaces.
#DEVICES_TO_ENABLE_ON_STARTUP="wifi"

# Radio devices to disable on shutdown: bluetooth, wifi, wwan
# (workaround for devices that are blocking shutdown).
#DEVICES_TO_DISABLE_ON_SHUTDOWN="bluetooth wifi wwan"

# Radio devices to enable on shutdown: bluetooth, wifi, wwan
# (to prevent other operating systems from missing radios).
#DEVICES_TO_ENABLE_ON_SHUTDOWN="wwan"

# Radio devices to enable on AC: bluetooth, wifi, wwan
#DEVICES_TO_ENABLE_ON_AC="bluetooth wifi wwan"

# Radio devices to disable on battery: bluetooth, wifi, wwan
#DEVICES_TO_DISABLE_ON_BAT="bluetooth wifi wwan"

# Radio devices to disable on battery when not in use (not connected):
# bluetooth, wifi, wwan
#DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE="bluetooth wifi wwan"
```


So tlp's default configuration doesn't restore device state **and** it masked systemd's rfkill service. I adjusted one line in tlp's configuration and rebooted:

```
DEVICES_TO_DISABLE_ON_STARTUP="bluetooth wifi wwan"
```


After the reboot, both the wifi and Bluetooth functionality were shut off! That's exactly what I needed.

### Extra credit

Thanks to a coworker, I was able to make a NetworkManager script to automatically shut off the wireless LAN whenever I connected to a network via ethernet. This is typically what I do when coming back from an in-person meeting to my desk (where I have ethernet connectivity).

If you want the same automation, just drop this script into `/etc/NetworkManager/dispatcher.d/70-wifi-wired-exclusive.sh` and make it executable:

```shell
#!/bin/bash
export LC_ALL=C

enable_disable_wifi ()
{
        result=$(nmcli dev | grep "ethernet" | grep -w "connected")
        if [ -n "$result" ]; then
                nmcli radio wifi off
        fi
}

if [ "$2" = "up" ]; then
        enable_disable_wifi
fi
```


Unplug the ethernet connection, start wifi, and then plug the ethernet connection back in. Once NetworkManager fully connects (DHCP lease obtained, connectivity check passes), the wireless LAN should shut off automatically.

 [1]: /wp-content/uploads/2015/03/ThinkPad-Carbon-X1.jpg
 [2]: https://wireless.wiki.kernel.org/en/users/documentation/rfkill
 [3]: http://www.freedesktop.org/software/systemd/man/systemd-rfkill@.service.html
 [4]: http://linrunner.de/en/tlp/tlp.html