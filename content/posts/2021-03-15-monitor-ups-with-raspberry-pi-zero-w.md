---
title: Monitor a UPS with a Raspberry Pi Zero W
author: Major Hayden
type: post
date: "2021-03-15"
slug: monitor-ups-with-raspberry-pi-zero-w
twitter:
  card: "summary_large_image"
  site: "@majorhayden"
  title: defending-losing-options-trades
  description: >-
    Monitor nearly any uninterruptible power supply (UPS) with a
    Raspberry Pi Zero W and HomeAssistant
  image: images/2021-03-power-plant.jpg
categories:
  - Blog Posts
tags:
  - linux
  - raspberrypi
---

{{< figure src="/images/2021-03-power-plant.jpg" alt="Power plant with four towers" position="center" >}}

After the recent [snow apocalypse that swept through Texas] followed by
[widespread power crisis], I realized that my UPS monitoring strategy needed
improvement. One had batteries that were near death and my other two had loads
that were not well balanced.

I have a few CyberPower UPS units and an old APC UPS. Although CyberPower does
offer [relatively expensive monitoring cards] that puts the UPS on the local
network, none of them worked with my 1350/1500VA units. However, all of them
do have USB serial connectivity and I wondered how I could monitor them more
effectively.

[snow apocalypse that swept through Texas]: https://en.wikipedia.org/wiki/February_2021_North_American_ice_storm
[widespread power crisis]: https://en.wikipedia.org/wiki/2021_Texas_power_crisis
[relatively expensive monitoring cards]: https://www.cyberpowersystems.com/products/ups/hardware/

## Enter the Raspberry Pi Zero W

The [Pi Zero W] is an extension of the old Pi Zero with wireless network
connectivity included. It also has a USB port available that would allow me to
connect it to a UPS. It runs an older Broadcom BCM2835 and only has 512MiB of
RAM, but that's plenty to do the job.

The [Vilros kit] contains nearly everything you need for a Pi Zero W. I added
on a 64GB SD card for $11 and that brought the total to just under $40 per
UPS.

[Pi Zero W]: https://www.raspberrypi.org/products/raspberry-pi-zero-w/
[Vilros kit]]: https://vilros.com/collections/raspberry-pi-kits/products/raspberry-pi-zero-w-basic-starter-kit-1

## Setting up

While the [Raspberry Pi OS] is popular, I've been using Arch Linux a lot
lately and decided to use [their build] for the Pi Zero W. The [installation
instructions for Arch] we perfect, except for one step: I needed wireless
network connectivity as soon as the Pi booted.

You can enable wireless network at boot time by following the Arch Linux
instructions and stopping just before you unmount the filesystems on the SD
card. The first step is to add a systemd-networkd config to use DHCP on the
wireless network interface:

```shell
cat << EOF >> root/etc/systemd/network/wlan0.network
[Match]
Name=wlan0

[Network]
DHCP=yes
EOF
```

Next, we need to store our `wpa_supplicant` configuration for `wlan0`.

```shell
wpa_passphrase "YOUR_SSID" "WIFI_PASSWORD" \
  > root/etc/wpa_supplicant/wpa_supplicant-wlan0.conf
```

This prepares the `wpa_supplicant` configuration at boot time, but we need to
tell systemd to start `wpa_supplicant` when the Pi boots:

```shell
ln -s \
   /usr/lib/systemd/system/wpa_supplicant@.service \
   root/etc/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service
```

We've now enabled DHCP at boot time, stored the wireless connection
credentials, and enabled `wpa_supplicant` at boot time. Follow the remaining
Arch Linux installation instructions starting with unmounting the `boot` and
`root` filesystems.

Pop the SD card into the Pi, connect your UPS' USB cable, and connect it to
power. Once it boots, be sure to follow the last two steps from the Arch Linux
installation instructions:

```shell
pacman-key --init
pacman-key --populate archlinuxarm
```

[Raspberry Pi OS]: https://www.raspberrypi.org/software/
[their build]: https://archlinuxarm.org/platforms/armv6/raspberry-pi
[installation instructions for Arch]: https://archlinuxarm.org/platforms/armv6/raspberry-pi

## Nuts and bolts

When it comes to monitoring UPS devices in Linux, it's hard to beat [Network
UPS Tools], or `nut`. Install it on your Pi:

```shell
pacman -S nut usbutils
```

Start by running `lsusb` to ensure your USB is connected and recognized:

```shell
$ lsusb
Bus 001 Device 003: ID 0764:0501 Cyber Power System, Inc. CP1500 AVR UPS
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

If you can't see the UPS, double check your USB cable. You may need to
disconnect and reconnect it after installing `nut` to pick up udev changes.

Next, it's time to update some configuration files. Start by opening
`/etc/nut/nut.conf` and setting the server mode to `netserver` so that nut can
listen on the network:

```ini
MODE=netserver
```

Open `/etc/nut/ups.conf` and tell `nut` how to talk to your UPS:

```ini
[amd-desktop]
driver = usbhid-ups
port = auto
desc = "CyberPower 1500VA AMD Desktop"
```

Almost all modern UPS units will use the `usbhid-ups` driver. The name in the
section header (`amd-desktop` in my example) is how the UPS is named when you
query `nut` for status.

Now we need to tell `nut` to listen on the network. I trust my local network,
so I open it up to the LAN. Edit `/etc/nut/upsd.conf` and adjust `LISTEN`:

```ini
# LISTEN <address> [<port>]
# LISTEN 127.0.0.1 3493
# LISTEN ::1 3493
LISTEN 0.0.0.0 3493
#
# This defaults to the localhost listening addresses and port 3493.
# In case of IP v4 or v6 disabled kernel, only the available one will be used.
```

The next step is to set up an admin user for `nut`. This is completely
optional, but you will need this if you want to tell `nut` to execute certain
commands on the UPS, such as disabling the beeping alarm or running self
tests. Edit `/etc/nut/upsd.users` and add a user:

```ini
[admin]
  password = ihavethepower
  actions = SET
  instcmds = ALL
```

We're ready to start the service and ensure it comes up on reboots:

```shell
systemctl enable --now nut-server
```

We can test it:

```shell
$ upsc -l
amd-desktop
$ upsc amd-desktop@localhost
battery.charge: 100
battery.charge.low: 10
battery.charge.warning: 20
battery.mfr.date: CPS
battery.runtime: 1875
battery.runtime.low: 300
battery.type: PbAcid
battery.voltage: 13.5
battery.voltage.nominal: 12
device.mfr: CPS
device.model:  CP 1350C
device.type: ups
driver.name: usbhid-ups
driver.parameter.pollfreq: 30
driver.parameter.pollinterval: 2
driver.parameter.port: auto
driver.parameter.synchronous: no
driver.version: 2.7.4
driver.version.data: CyberPower HID 0.4
driver.version.internal: 0.41
input.transfer.high: 140
input.transfer.low: 90
input.voltage: 124.0
input.voltage.nominal: 120
output.voltage: 124.0
ups.beeper.status: enabled
ups.delay.shutdown: 20
ups.delay.start: 30
ups.load: 17
ups.mfr: CPS
ups.model:  CP 1350C
ups.productid: 0501
ups.realpower.nominal: 298
ups.status: OL
ups.test.result: Done and passed
ups.timer.shutdown: -60
ups.timer.start: 0
ups.vendorid: 0764
```

Sweet! You can test connectivity from another system on your network by
specifying the IP address instead of `localhost`.

[Network UPS Tools]: https://networkupstools.org/

## Adding HomeAssistant

Setting up HomeAssistant is well outside the scope of this post, but it can
monitor all kinds of things on your home network and allow you to run certain
automations when devices get into a certain state. You can put a sensor on
your garage door and get a text when it opens or closes. You can lower your
thermostat when your CPU temperature gets too hot.

Fortunately, you can also monitor UPS devices and create alerts! Follow these
steps to add your UPS to HomeAssistant:

1. From the main HomeAssistant screen, click **Configuration**.
2. Click **Integrations**.
3. Click **Add Integration** at the bottom right.
4. Search for `nut` in the list and add it.
5. In the next window, specify your Pi's IP address and port for `nut`. Add
   your username and password that you configured in `upsd.users` earlier.
6. Click **Submit**.
7. Choose all of the aspects of your UPS you want to monitor. I keep an eye on
   load, battery voltage, input voltage, and runtime.
8. Click **Submit** again and your UPS should appear in the integrations list!

Once HomeAssistant monitors your UPS for a while, you should have some useful
data! Here's a graph of my UPS load during my workday:

{{< figure src="/images/2021-03-homeassistant-screenshot.png" alt="Graph of UPS load from HomeAsssistant" position="center" >}}

You can see that my workday starts just after 6AM and ends after 4PM. Using
this data, you can set up all kinds of automations when UPS load is too high,
input voltage is too low (brownout/blackout), or the runtime falls to a low
level (could be dying batteries).

The Pi Zero W draws a tiny amount of power and can monitor your UPS for an
extended period without having an impact on the runtime or your wallet! 💸

[HomeAssistant]: https://www.home-assistant.io/

*Photo credit: [Johannes Plenio on Unsplash](https://unsplash.com/photos/EK0l7RhAB8E)*
