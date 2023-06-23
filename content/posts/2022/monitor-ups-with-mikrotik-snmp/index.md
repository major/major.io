---
aliases:
- /2022/10/28/monitor-ups-with-mikrotik-snmp/
author: Major Hayden
date: '2022-10-28'
summary: Mikrotik routers and switches serve as efficient network devices, but they
  know other tricks, too. Monitor your UPS with a Mikrotik device and query it via
  SNMP. 🔌
tags:
- mikrotik
- networking
- snmp
- ups
title: Monitor a UPS with a Mikrotik router via SNMP
---

Cyberpower UPS units saved me from plenty of issues in the past with power outages.
However, although I love the units themselves, I found that the quality of replacement batteries varies widely.
This leads me to keep a close watch on my UPS units and test them regularly.

Energy conservation ranks high on my list of priorities, too.
I monitor the power draw on my UPS units to know about usage spikes or to review electricity consumption after I make changes.

My Raspberry Pi did a great job of monitoring my UPS for my network devices but it failed after a recent reboot.
My [network woes] from September left me with a [Mikrotik hEXs] running my home network and I noticed it had a USB port.

Can you monitor a UPS with a Mikrotik device and query its status remotely?
**You can!**

[network woes]: /2022/09/02/pxe-boot-netboot.xyz-on-a-mikrotik-router/
[Mikrotik hEXs]: https://mikrotik.com/product/hex_s

# Initial setup

My Cyberpower [CP1500AVRLCD] has a USB port on the back for monitoring and control.
The hEXs router has a USB-A port on the side that can be used for mass storage, LTE modems, and yes -- UPS units.

However, UPS monitoring does not come standard with RouterOS 7.x and it must be installed via a separate package.
Follow these steps to get started:

1. Identify the CPU architecture of your Mikrotik.
   It should be shown on the product page.
   The [Mikrotik hEXs] is a MMIPS ([microMIPS]) device.
2. Go to the RouterOS [download page] and download the **Extra packages** file for your architecture.
3. Unpack the zip file you downloaded and locate the `ups-7.x-mmips.npk` package.
4. Upload the `ups-7.x-mmips.npk` file via your preferred method.
   FTP, ssh, and the web interface work well for this.
5. Reboot your Mikrotik device.

[CP1500AVRLCD]: https://www.cyberpowersystems.com/product/ups/intelligent-lcd/cp1500avrlcd/
[microMIPS]: https://en.wikipedia.org/wiki/MIPS_architecture#microMIPS
[download page]: https://mikrotik.com/download

# Enable monitoring

After the reboot, your Mikrotik should now have a `/system/ups` entry on the command line.
Let's add monitoring for our UPS:

```text
[major@hexs] > /system/ups
[major@hexs] /system/ups> add name=ups min-runtime=never port=usbhid1
```

If you don't know what your port is called, type in `add port=` and press `TAB` to see the available ports.
Refer to the [Mikrotik System/UPS manual] for more help here.

I set the `min-runtime` to `never` which means that the Mikrotik will never hibernate even if the UPS power runs low.
It uses so little power and it's so critical for my home network that it should be the last system to go offline during an outage.

All that's left is to enable read-only SNMP so that we can monitor the UPS remotely.
Back to the Mikrotik command line:

```text
[major@hexs] > /snmp/set enabled=yes
```

This enables unrestricted read-only SNMP access for your entire network without authentication under the community name _public_.
I restrict SNMP access with firewall rules but you may want to consider further restrictions on your SNMP community.

[Mikrotik System/UPS manual]: https://wiki.mikrotik.com/wiki/Manual:System/UPS

# Getting data

From another machine on the network, I dumped all of the SNMP data from the Mikrotik into a file:

```console
$ snmpwalk -v2c -c public 192.168.10.1 | tee -a /tmp/snmpwalk.txt
```

Then I looked for my UPS' model name:

```console
$ grep LCD /tmp/snmpwalk.txt 
SNMPv2-SMI::mib-2.33.1.1.2.0 = STRING: "CP1500AVRLCDa"
SNMPv2-SMI::mib-2.47.1.1.1.1.2.262146 = STRING: "CPS CP1500AVRLCDa"
```

Let's see if the first entry gives us the data we need:

```console
> $ grep "^SNMPv2-SMI::mib-2.33" /tmp/snmpwalk.txt 
SNMPv2-SMI::mib-2.33.1.1.2.0 = STRING: "CP1500AVRLCDa"
SNMPv2-SMI::mib-2.33.1.1.3.0 = ""
SNMPv2-SMI::mib-2.33.1.2.1.0 = INTEGER: 2
SNMPv2-SMI::mib-2.33.1.2.3.0 = INTEGER: 103
SNMPv2-SMI::mib-2.33.1.2.4.0 = INTEGER: 100
SNMPv2-SMI::mib-2.33.1.2.5.0 = INTEGER: 0
SNMPv2-SMI::mib-2.33.1.2.7.0 = INTEGER: 0
SNMPv2-SMI::mib-2.33.1.3.2.0 = INTEGER: 1
SNMPv2-SMI::mib-2.33.1.3.3.1.2.3 = INTEGER: 0
SNMPv2-SMI::mib-2.33.1.3.3.1.3.3 = INTEGER: 122
SNMPv2-SMI::mib-2.33.1.4.3.0 = INTEGER: 1
SNMPv2-SMI::mib-2.33.1.4.4.1.2.3 = INTEGER: 122
SNMPv2-SMI::mib-2.33.1.4.4.1.5.3 = INTEGER: 8
SNMPv2-SMI::mib-2.33.1.6.1.0 = Gauge32: 0
```

What the heck do all these numbers mean?
A quick trip to a [MIB browser] shows us that there are a few important items here:

* `upsOutputPercentLoad` is `1.4.4.1.5` (8%)
* `upsOutputVoltage` is `1.4.4.1.2` (122V)
* `upsEstimatedChargeRemaining` is `1.2.4.0` (100%)

These are the three numbers I care most about.
However, the percent load of 8% isn't terribly useful.
I'd rather have watts.

Let's write a script to get the value, and convert the percentage to watts:

```text
#!/bin/bash
set -euo pipefail

# From the CP1500AVRLCDa spec sheet
MAX_LOAD_WATTS=815

# SNMP MIB for load percentage
SNMP_MIB="SNMPv2-SMI::mib-2.33.1.4.4.1.5.3"

# Get the load integer only.
CURRENT_LOAD=$(snmpget -Oqv -v2c -c public 192.168.10.1 $SNMP_MIB)

# Convert the percentage into wattage consumed right now.
CURRENT_WATTS=$(($MAX_LOAD_WATTS * $CURRENT_LOAD / 100))

echo "${CURRENT_WATTS}"
```

Let's test the script!

```console
$ ./get_wattage.sh
65
```

Awesome! 🎉

[MIB browser]: https://www.oidview.com/mibs/0/UPS-MIB.html