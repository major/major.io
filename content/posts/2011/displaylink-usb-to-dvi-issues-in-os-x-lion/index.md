---
aliases:
- /2011/11/17/displaylink-usb-to-dvi-issues-in-os-x-lion/
author: Major Hayden
date: 2011-11-17 13:38:48
dsq_thread_id:
- 3642806731
tags:
- mac
title: DisplayLink USB to DVI issues in OS X Lion
---

I added a [DisplayLink USB to DVI adapter][1] to my MacBook Pro a while back and it occasionally has some issues where it won't start the display after connecting the USB cable. My logs in Console.app usually contain something like this:

```
The IOUSBFamily is having trouble enumerating a USB device that has been plugged in.  It will keep retrying.  (Port 4 of Hub at 0xfa100000)
The IOUSBFamily was not able to enumerate a device.
The IOUSBFamily is having trouble enumerating a USB device that has been plugged in.  It will keep retrying.  (Port 4 of Hub at 0xfa100000)
The IOUSBFamily was not able to enumerate a device.
The IOUSBFamily is having trouble enumerating a USB device that has been plugged in.  It will keep retrying.  (Port 4 of Hub at 0xfa100000)
The IOUSBFamily gave up enumerating a USB device after 10 retries.  (Port 4 of Hub at 0xfa100000)
The IOUSBFamily was not able to enumerate a device.
```


The solution is a bit goofy, but here's what you can do:

  1. Unplug the adapter from the USB port.
  2. Disconnect the DVI cable from the DisplayLink adapter.
  3. Power off the display you normally use with the adapter.
  4. Connect the USB cable between your computer and the DisplayLink adapter.
  5. Wait for your displays to flash (as if a new display was connected).
  6. The light on your DisplayLink adapter should be on now.
  7. Connect the DVI cable to the DisplayLink adapter.
  8. Wait a few seconds and then power on the display connected to the adapter.

If this process doesn't work, try a reboot and repeat the process once Finder finishes starting up.

 [1]: http://www.displaylink.com/