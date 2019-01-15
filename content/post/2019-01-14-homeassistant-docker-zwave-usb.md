---
title: Running Home Assistant in a Docker container with a Z-Wave USB stick
author: Major Hayden
type: post
date: "2019-01-14"
slug: running-home-assistant-in-a-docker-container-with-zwave-usb-stick
categories:
  - Blog Posts
tags:
  - docker
  - homeassistant
  - fedora
  - security
---

The [Home Assistant] project provides a great open source way to get started
with home automtion that can be entirely self-contained within your home. It
already has plenty of [integrations] with external services, but it can also
monitor [Z-Wave] devices at your home or office.

Here are my devices:

* [Monoprice Z-Wave Garade Door Sensor]
* [Aeotec Z-Stick Gen5 (ZW090)]
* Fedora Linux server with Docker installed

## Install the Z-Wave stick

Start by plugging the Z-Stick into your Linux server. Run `lsusb` and it should appear in the list:

```
# lsusb | grep Z-Stick
Bus 003 Device 006: ID 0658:0200 Sigma Designs, Inc. Aeotec Z-Stick Gen5 (ZW090) - UZB
```

The system journal should also tell you which TTY is assigned to the USB
stick (run `journalctl --boot` and search for `ACM`):

```
kernel: usb 3-3.2: USB disconnect, device number 4
kernel: usb 3-1: new full-speed USB device number 6 using xhci_hcd
kernel: usb 3-1: New USB device found, idVendor=0658, idProduct=0200, bcdDevice= 0.00
kernel: usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
kernel: cdc_acm 3-1:1.0: ttyACM0: USB ACM device
kernel: usbcore: registered new interface driver cdc_acm
kernel: cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
```

In my case, my device is `/dev/ttyACM0`. If you have other serial devices
attached to your system, your Z-Stick may show up as `ttyACM1` or `ttyACM2`.

## Using Z-Wave in the Docker container

If you use `docker-compose`, simply add a `devices` section to your existing
YAML file:

```yaml
version: '2'
services:
  home-assistant:
    ports:
      - "8123:8123/tcp"
    network_mode: "host"
    devices:
      - /dev/ttyACM0
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /mnt/raid/hass/:/config:Z
    image: homeassistant/home-assistant
    restart: always
```

You can add the device to manual `docker run` commands by adding `--device
/dev/ttyACM0` to your existing command line.

## Pairing

For this step, always refer to the instructions that came with your Z-Wave
device since some require different pairing steps. In my case, I installed
the battery, pressed the button inside the sensor, and paired the device:

* Go to the Home Assistant web interface
* Click **Configuration** on the left
* Click **Z-Wave** on the right
* Click **Add Node** and follow the steps on screen

## Understanding how the sensor works

Now that the sensor has been added, we need to understand how it works. One
of the entities the sensor provides is an `alarm_level`. It has two possible
values:

* `0`: the sensor is tilted vertically (garage door is closed)
* `255`: the sensor is tilted horizontally (garage door is open)

If the sensor changes from `0` to `255`, then someone opened the garage door.
Closing the door would result in the sensor changing from `255` to `0`.

## Adding automation

Let's add automation to let us know when the door is open:

* Click **Configuration** on the left
* Click **Automation** on the right
* Click the plus (+) at the bottom right
* Set a good name (like "Garage door open")
* Under triggers, look for `Vision ZG8101 Garage Door Detector Alarm Level`
  and select it
* Set **From** to `0`
* Set **To** to `255`
* Leave the **For** spot empty

Now that we can detect the garage door being open, we need a notification
action. I love [PushBullet] and I have an action set up for PushBullet
notifications already. Here's how to use an action:

* Select **Call Service** for **Action Type** in the **Actions** section
* Select a service to call when the trigger occurs
* **Service data** should contain the json that contains the notification
  message and title

Here's an example of my service data:

```json
{
  "message": "Someone opened the garage door at home.",
  "title": "Garage door opened"
}
```

Press the orange and white save icon at the bottom right and you are ready to
go! You can tilt the sensor in your hand to test it or attach it to your
garage door and test it there.

If you want to know when the garage door is closed, follow the same steps
above, but use `255` for **From** and `0` for **To**.

[Home Assistant]: https://www.home-assistant.io/
[integrations]: https://www.home-assistant.io/components/
[Z-Wave]: https://en.wikipedia.org/wiki/Z-Wave
[Monoprice Z-Wave Garade Door Sensor]: https://www.amazon.com/Monoprice-Z-Wave-Garage-Door-Sensor/dp/B00V5IQ8E8
[Aeotec Z-Stick Gen5 (ZW090)]: https://aeotec.com/z-wave-usb-stick
[PushBullet]: https://www.pushbullet.com/
