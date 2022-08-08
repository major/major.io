---
author: Major Hayden
date: '2021-10-23'
summary: >-
  One of the smallest ThinkPads delivers one of the best experiences I've had on
  a laptop. 💻
images:
- images/2021-10-23-thinkpad-x1-nano.png
slug: thinkpad-x1-nano-gen1-review
tags:
- fedora
- laptop
- lenovo
- linux
title: ThinkPad X1 Nano Gen 1 Review
---

{{< figure src="/images/2021-10-23-thinkpad-x1-nano.png" alt="ThinkPad X1 Nano Gen 1" position="center" >}}

My ThinkPad T490 was showing its age and [wrestling with the internal NVIDIA
GPU] was a constant pain. Other than some unexpected early battery wear, it has
been a good laptop for me.

However, the annual Lenovo sale email came through my inbox recently and I
decided to look for something new. I picked up an X1 Nano Gen 1 and the
experience has been good so far.

## My search

My criteria for a new laptop included:

- Under $2,000
- Durable and well built
- No dedicated GPU
- Screen resolution better than FHD (1920x1080)
- Good Linux support
- High quality keyboard
- MicroSD would be nice, but not required
- Battery life of 8 hours or more

I hoped to find a laptop with an AMD chip that met my requirements because I
really like the technologies that AMD packs into their designs. Every AMD laptop
I could find had a FHD screen or worse on a 13-15" screen. My T490 was the high
resolution model and I did give the latest Dell XPS 13 a shot, but the screen
resolution left me with really fuzzy text in terminals.

As an aside, I've now purchased two Dell XPS 13 laptops about three years apart
and I've returned both. These devices look great on paper but I was really
dissatisfied with them in person.

## Why I picked the X1 Nano

The Nano met nearly all of my requirements except for the MicroSD reader. It
only has three ports: two USB-C ports and a combination microphone/headphone
port. Everything else was great!

The screen is 2160x1350, which is slightly better than FHD and it's a great
balance between higher resolution and reduced battery usage.

It came out to $1,581 with taxes included.

## My thoughts

Most of the thoughts I have are fairly subjective, but NotebookCheck has an
[extremely detailed review] that goes into more detail than I will ever need. If
you're wondering about screen view angles, nits, and deep dives into battery
usage, the folks at NotebookCheck are hard to beat.

I installed Fedora 35 Beta easily and all of the hardware was fully recognized
without any extra work. That surprised me since this laptop has plenty of modern
hardware inside and it seems like every ThinkPad has one or two quirks to fix
after installation.

I'm a big fan of [tlp] for power management. One thing I noticed with the X1
Nano is that it performs with *very low* latency even when I crank down tlp to
its most aggressive power saving settings. Screen refresh is immediate,
terminals perform well, and Firefox seems to run at normal speed even with
`powertop` showing all power saving settings set to the maximum. On my T490, I'd
notice lag in my terminals while typing and Firefox had some weird artifacting
that would appear briefly between page loads.

My battery life experience with the Nano is **stellar**. I've been working on
this post for about 30-45 minutes with plenty of browser tabs open and the
battery life has gone from about 82% to 77% during that time. This makes a world
of difference for me when I take my ham radio gear into the field and I need a
laptop battery that lasts.

One of my biggest fears for this laptop was the keyboard and touchpad. ThinkPad
input devices are typically some of the best in the industry and I wondered how
well that would work in a smaller form factor. They worked hard to shrink the
buttons that would impact a user the least. The buttons along the edge shrunk
the most, but the letter and number keys seem the same size. Key travel is a
little reduced from the T490 but this is a *very thin* laptop.

The touchpad feels great and the size works just fine for me. The mouse buttons
just above the touchpad are definitely not as tall as the ones on the T490 and
that takes some adjustment. As for the trackpoint (the red "keyboard nipple"),
I've never been good with these and I'm just as bad with this one as all of the
other ones. 🤣

Sound from the speakers is above average, but it's not going to win any awards.
The microphone and webcam perform just as well as any other ThinkPad I've
owned.

## My configuration

My X1 Nano Gen 1 came with a [i5-1140G7], 16GB of RAM, and a 512GB NVMe disk
(Western Digital SN530). Here's a look at what's on the PCI bus and USB hubs:

```console
$ lspci
00:00.0 Host bridge: Intel Corporation Device 9a12 (rev 01)
00:02.0 VGA compatible controller: Intel Corporation Device 9a40 (rev 01)
00:04.0 Signal processing controller: Intel Corporation TigerLake-LP Dynamic Tuning Processor Participant (rev 01)
00:06.0 PCI bridge: Intel Corporation 11th Gen Core Processor PCIe Controller (rev 01)
00:07.0 PCI bridge: Intel Corporation Tiger Lake-LP Thunderbolt 4 PCI Express Root Port #1 (rev 01)
00:07.2 PCI bridge: Intel Corporation Tiger Lake-LP Thunderbolt 4 PCI Express Root Port #2 (rev 01)
00:08.0 System peripheral: Intel Corporation GNA Scoring Accelerator module (rev 01)
00:0a.0 Signal processing controller: Intel Corporation Tigerlake Telemetry Aggregator Driver (rev 01)
00:0d.0 USB controller: Intel Corporation Tiger Lake-LP Thunderbolt 4 USB Controller (rev 01)
00:0d.2 USB controller: Intel Corporation Tiger Lake-LP Thunderbolt 4 NHI #0 (rev 01)
00:0d.3 USB controller: Intel Corporation Tiger Lake-LP Thunderbolt 4 NHI #1 (rev 01)
00:12.0 Serial controller: Intel Corporation Tiger Lake-LP Integrated Sensor Hub (rev 20)
00:14.0 USB controller: Intel Corporation Tiger Lake-LP USB 3.2 Gen 2x1 xHCI Host Controller (rev 20)
00:14.2 RAM memory: Intel Corporation Tiger Lake-LP Shared SRAM (rev 20)
00:14.3 Network controller: Intel Corporation Wi-Fi 6 AX201 (rev 20)
00:15.0 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP Serial IO I2C Controller #0 (rev 20)
00:15.3 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP Serial IO I2C Controller #3 (rev 20)
00:16.0 Communication controller: Intel Corporation Tiger Lake-LP Management Engine Interface (rev 20)
00:1f.0 ISA bridge: Intel Corporation Device a087 (rev 20)
00:1f.3 Audio device: Intel Corporation Tiger Lake-LP Smart Sound Technology Audio Controller (rev 20)
00:1f.4 SMBus: Intel Corporation Tiger Lake-LP SMBus Controller (rev 20)
00:1f.5 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP SPI Controller (rev 20)
04:00.0 Non-Volatile memory controller: Sandisk Corp Device 5008 (rev 01)
```

```console
$ lsusb
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 003: ID 13d3:5411 IMC Networks Integrated Camera
Bus 003 Device 002: ID 06cb:00bd Synaptics, Inc. Prometheus MIS Touch Fingerprint Reader
Bus 003 Device 004: ID 8087:0026 Intel Corp. AX201 Bluetooth
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

The webcam, fingerprint reader, and the bluetooth/wifi card are on the USB bus
and this is fairly common for modern ThinkPads.

## Conclusion

This is an all-around great laptop and I'd highly recommend it for anyone who
travels often. It's *incredibly* light and I barely notice when it's in a
backpack. I wouldn't use this as a desktop replacement, but it can drive
external monitors if needed and it performs really well on AC power. Text in
terminals is easy to read and you won't spend much time wrestling with hardware
support in Linux.

[wrestling with the internal NVIDIA GPU]: /2020/01/24/disable-nvidia-gpu-thinkpad-t490/
[extremely detailed review]: https://www.notebookcheck.net/Lenovo-ThinkPad-X1-Nano-Laptop-Review-Less-than-1-kg-for-the-Business-Subnotebook-with-LTE.517858.0.html
[tlp]: https://linrunner.de/tlp/
[i5-1140G7]: https://ark.intel.com/content/www/us/en/ark/products/208659/intel-core-i51140g7-processor-8m-cache-up-to-4-20-ghz-with-ipu.html

*Photo credit: [Lenovo](https://www.lenovo.com/us/en/)*
