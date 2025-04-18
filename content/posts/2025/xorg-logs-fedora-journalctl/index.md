---
author: Major Hayden
date: '2025-02-16'
summary: |
  A recent switch back to i3 (from sway) left me wondering how to examine just the Xorg logs sent to journald.
tags: 
  - i3
  - fedora
  - linux
title: Viewing Xorg logs with journalctl in Fedora
coverAlt: High altitude view of an island with mountains and a beach
coverCaption: |
  [Reinaldo Photography](https://unsplash.com/photos/an-aerial-view-of-a-small-island-in-the-middle-of-the-ocean-4I0kdYvHJAI) via Unsplash
---

I love being an early adopter and trudging off into the unknown.
After all, that's one of the best ways to learn new things and you end up improving the experience for everyone who comes behind you.
However, things can get a little frustrating from time to time especially when your daily work dictates that your desktop works really well. 😉

Sway has been my desktop of choice for a few years and although it seems to work well, I ran into lots of issues with Wayland.
It was easy to plot a course around most of these problems, but not all of them.

I've recently run back to safety with my old, trusty, i3 window manager in Xorg.
Then I realized a few of my Xorg configuration weren't taking effect and I couldn't figure out how to isolate the Xorg logs in the system journal to narrow down the problem.

Skip to the end if you're short on time or peruse the next section if you haven't been deep in the innards of your system journal in a while. 🔍

## Journal metadata

Every journal entry in journald has metadata attached to it which you can use to filter the logs.
Most people know about filtering based on systemd services, like this:

```text
> journalctl --boot --unit chronyd.service | head
systemd[1]: Starting chronyd.service - NTP client/server...
chronyd[2662]: chronyd version 4.6.1 starting (+CMDMON +NTP +REFCLOCK +RTC +PRIVDROP +SCFILTER +SIGND +ASYNCDNS +NTS +SECHASH +IPV6 +DEBUG)
chronyd[2662]: Using leap second list /usr/share/zoneinfo/leap-seconds.list
chronyd[2662]: Frequency -3.595 +/- 6.086 ppm read from /var/lib/chrony/drift
chronyd[2662]: Loaded seccomp filter (level 2)
systemd[1]: Started chronyd.service - NTP client/server.
chronyd[2662]: Added source 192.168.10.1
chronyd[2662]: Selected source 208.67.72.50 (2.fedora.pool.ntp.org)
chronyd[2662]: System clock TAI offset set to 37 seconds
chronyd[2662]: Selected source 173.73.96.68 (2.fedora.pool.ntp.org)
```

This command shows all of the messages from the `chronyd` service since the last boot.
However, we can get much more specific with our filtering using other criteria.

## Examining metadata

You can examine the metadata behind each log line with the json output in journalctl:

```text
> journalctl --boot --unit chronyd.service -o json -n 1 | jq
{
  "_CMDLINE": "/usr/sbin/chronyd -F 2",
  "_SYSTEMD_CGROUP": "/system.slice/chronyd.service",
  "_MACHINE_ID": "xxxxx",
  "_UID": "990",
  "SYSLOG_TIMESTAMP": "Feb 16 13:55:59 ",
  "__SEQNUM_ID": "c94633ee6da2480ca4602ca6ab47f82a",
  "_PID": "2662",
  "PRIORITY": "6",
  "_HOSTNAME": "zorro",
  "_SYSTEMD_SLICE": "system.slice",
  "SYSLOG_FACILITY": "3",
  "_GID": "989",
  "_SYSTEMD_INVOCATION_ID": "156fce8836374564b01aeb6628160ccb",
  "__CURSOR": "s=c94633ee6da2480ca4602ca6ab47f82a;i=19fb3a;b=ed9e1fccb1744136a3d726bbf2425388;m=33abfdf67;t=62e47cbf2b72f;x=f9a8d4e3bc4fef30",
  "__MONOTONIC_TIMESTAMP": "13870554983",
  "_SOURCE_REALTIME_TIMESTAMP": "1739735759501027",
  "_TRANSPORT": "syslog",
  "_EXE": "/usr/sbin/chronyd",
  "_SYSTEMD_UNIT": "chronyd.service",
  "SYSLOG_IDENTIFIER": "chronyd",
  "_BOOT_ID": "ed9e1fccb1744136a3d726bbf2425388",
  "__REALTIME_TIMESTAMP": "1739735759501103",
  "__SEQNUM": "1702714",
  "_RUNTIME_SCOPE": "system",
  "SYSLOG_PID": "2662",
  "_CAP_EFFECTIVE": "2000400",
  "MESSAGE": "Selected source 173.73.96.68 (2.fedora.pool.ntp.org)",
  "_COMM": "chronyd",
  "_SELINUX_CONTEXT": "system_u:system_r:chronyd_t:s0"
}
```

The most helpful one for us is `_COMM_`.
We can use it to limit our search solely to Xorg logs.

Every Xorg startup has a line with the Xorg version that looks like this:
`X.Org X Server 1.21.1.15`.
Let's search for that:

```text
> journalctl --boot -o json | grep -i "x.org x server" | jq
{
  "_HOSTNAME": "zorro",
  "_BOOT_ID": "ed9e1fccb1744136a3d726bbf2425388",
  "_SYSTEMD_INVOCATION_ID": "5cf933063b1246909d4ea15e7154bff4",
  "_MACHINE_ID": "xxxxx",
  "__CURSOR": "s=c94633ee6da2480ca4602ca6ab47f82a;i=19de06;b=ed9e1fccb1744136a3d726bbf2425388;m=4597347;t=62e2f4fcc855d;x=b4f482006e1523ff",
  "__MONOTONIC_TIMESTAMP": "72971079",
  "_SYSTEMD_SESSION": "2",
  "_SYSTEMD_SLICE": "user-1000.slice",
  "_SELINUX_CONTEXT": "system_u:system_r:xdm_t:s0-s0:c0.c1023",
  "__SEQNUM_ID": "c94633ee6da2480ca4602ca6ab47f82a",
  "_AUDIT_LOGINUID": "1000",
  "__REALTIME_TIMESTAMP": "1739630597408093",
  "_CMDLINE": "/usr/libexec/Xorg vt2 -displayfd 3 -auth /run/user/1000/gdm/Xauthority -nolisten tcp -background none -noreset -keeptty -novtswitch -verbose 3",
  "_AUDIT_SESSION": "2",
  "_SYSTEMD_USER_SLICE": "-.slice",
  "__SEQNUM": "1695238",
  "_GID": "1000",
  "_RUNTIME_SCOPE": "system",
  "SYSLOG_IDENTIFIER": "/usr/libexec/gdm-x-session",
  "MESSAGE": "X.Org X Server 1.21.1.15",
  "_STREAM_ID": "7f35e3ce14d44dc8b589be76d4d355d9",
  "_TRANSPORT": "stdout",
  "_CAP_EFFECTIVE": "0",
  "_SYSTEMD_UNIT": "session-2.scope",
  "_UID": "1000",
  "_EXE": "/usr/libexec/Xorg",
  "PRIORITY": "4",
  "_COMM": "Xorg",
  "_SYSTEMD_CGROUP": "/user.slice/user-1000.slice/session-2.scope",
  "_SYSTEMD_OWNER_UID": "1000",
  "_PID": "3929"
}
```

Note that the value for `_COMM` is `Xorg`.
We can use that to search our logs with ease using the `cat` output from journalctl, which makes the output as terse as possible.
It removes all the headers and make it look like you're reading a plain old text log file:

```text
> journalctl --output cat --boot _COMM=Xorg | head
(--) Log file renamed from "/home/major/.local/share/xorg/Xorg.pid-3929.log" to "/home/major/.local/share/xorg/Xorg.0.log"
X.Org X Server 1.21.1.15
X Protocol Version 11, Revision 0
Current Operating System: Linux zorro 6.12.13-200.fc41.x86_64 #1 SMP PREEMPT_DYNAMIC Sat Feb  8 20:05:26 UTC 2025 x86_64
Kernel command line: BOOT_IMAGE=(hd0,gpt2)/vmlinuz-6.12.13-200.fc41.x86_64 root=UUID=bae22798-ce48-43e9-ac24-7bf7f7158e90 ro rootflags=subvol=root rd.luks.uuid=luks-defea11e-374c-48ab-83df-4f06c4c02186 rhgb quiet
Build ID: xorg-x11-server 21.1.15-1.fc41
Current version of pixman: 0.44.2
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Markers: (--) probed, (**) from config file, (==) default setting,
```

In my particular case, I was missing the amdgpu driver for Xorg.
I installed the `xorg-x11-drv-amdgpu` package, rebooted, and now my logs showed the driver being loaded on startup:

```text
> journalctl --output cat --boot _COMM=Xorg | grep -i amdgpu | head
(II) Applying OutputClass "AMDgpu" to /dev/dri/card1
	loading driver: amdgpu
(==) Matched amdgpu as autoconfigured driver 0
(II) LoadModule: "amdgpu"
(II) Loading /usr/lib64/xorg/modules/drivers/amdgpu_drv.so
(II) Module amdgpu: vendor="X.Org Foundation"
(II) AMDGPU: Driver for AMD Radeon:
	All GPUs supported by the amdgpu kernel driver
(II) AMDGPU(0): Creating default Display subsection in Screen section
(==) AMDGPU(0): Depth 24, (--) framebuffer bpp 32
```

## Further reading

There are _tons_ of ways to filter journald logs and one of the best resources for learning about all of them is the [journalctl man page](https://www.freedesktop.org/software/systemd/man/latest/journalctl.html).
There's also a [helpful journalctl cheat sheet](https://gist.github.com/sergeyklay/f401dbc8286f732783e05072f03ecb61) on GitHub.
