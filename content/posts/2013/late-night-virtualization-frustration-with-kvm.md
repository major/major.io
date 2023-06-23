---
aliases:
- /2013/03/20/late-night-virtualization-frustration-with-kvm/
author: Major Hayden
date: 2013-03-20 05:07:21
dsq_thread_id:
- 3642807146
tags:
- command line
- fedora
- kvm
- sysadmin
- virtualization
title: Late night virtualization frustration with kvm
---

I dragged out an old [Aopen MP57-D][1] tonight that was just sitting in the closet and decided to load up kvm on Fedora 18. I soon found myself staring at a very brief error message upon bootup:

```
kvm: disabled by bios
```

After a reboot, the BIOS screen was up and I saw that Virtualization and VT-d were both enabled. Trusted execution (TXT) was disabled, so I enabled it for kicks and rebooted. Now I had two errors:

```
kvm: disable TXT in the BIOS or activate TXT before enabling KVM
kvm: disabled by bios
```

Time for another trip to the BIOS. I disabled TXT, rebooted, and I was _back to the same error where I first started_. A quick check of `/proc/cpuinfo` showed that I had the right processor extensions. Even the output of `lshw` showed that I should be ready to go. Some digging in Google led me to a [blog post for a fix on Dell Optiplex hardware][2].

The fix was to do this:

  1. Within the BIOS, **disable** virtualization, VT-d, and TXT
  2. Save the BIOS configuration, reboot, and **pull power to the computer at grub**
  3. Within the BIOS, **enable** virtualization and VT-d but leave TXT disabled
  4. Save the BIOS configuration, reboot, and **pull power to the computer at grub**
  5. Boot up the computer normally

Although it seems a bit archaic, this actually fixed my problem and set me on my way.

 [1]: http://global.aopen.com/products_detail.aspx?Auno=3047
 [2]: http://reidablog.blogspot.com/2008/06/with-correct-bios-settings-enabled-on.html