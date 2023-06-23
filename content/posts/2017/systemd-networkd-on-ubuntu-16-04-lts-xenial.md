---
aliases:
- /2017/01/15/systemd-networkd-on-ubuntu-16-04-lts-xenial/
author: Major Hayden
date: 2017-01-15 15:24:40
dsq_thread_id:
- 5464778870
tags:
- networking
- openstack
- systemd
- systemd-networkd
- ubuntu
title: systemd-networkd on Ubuntu 16.04 LTS (Xenial)
---

My OpenStack cloud depends on Ubuntu, and the latest release of OpenStack-Ansible (what I use to deploy OpenStack) requires Ubuntu 16.04 at a minimum. I tried upgrading the servers in place from Ubuntu 14.04 to 16.04, but that didn't work so well. Those servers wouldn't boot and the only recourse was a re-install.

Once I finished re-installing them (and wrestling with several installer bugs in Ubuntu 16.04), it was time to set up networking. The traditional network configurations in `/etc/network/interfaces` are fine, but they weren't working the same way they were in 14.04. The VLAN configuration syntax appears to be different now.

But wait - 16.04 has systemd 229! I can use systemd-networkd to configure the network in a way that is a lot more familiar to me. I've made posts about systemd-networkd before and the simplicity in the configurations.

I started with some simple configurations:

```
root@hydrogen:~# cd /etc/systemd/network
root@hydrogen:/etc/systemd/network# cat enp3s0.network
[Match]
Name=enp3s0

[Network]
VLAN=vlan10
root@hydrogen:/etc/systemd/network# cat vlan10.netdev
[NetDev]
Name=vlan10
Kind=vlan

[VLAN]
Id=10
root@hydrogen:/etc/systemd/network# cat vlan10.network
[Match]
Name=vlan10

[Network]
Bridge=br-mgmt
root@hydrogen:/etc/systemd/network# cat br-mgmt.netdev
[NetDev]
Name=br-mgmt
Kind=bridge
root@hydrogen:/etc/systemd/network# cat br-mgmt.network
[Match]
Name=br-mgmt

[Network]
Address=172.29.236.21/22
```


Here's a summary of the configurations:

  * Physical network interface is `enp3s0`
  * VLAN 10 is trunked down from a switch to that interface
  * Bridge `br-mgmt` should be on VLAN 10 (only send/receive traffic tagged with VLAN 10)

Once that was done, I restarted systemd-networkd to put the change into effect:

```
# systemctl restart systemd-networkd
```


Great! Let's check our work:

```
root@hydrogen:~# brctl show
bridge name bridge id       STP enabled interfaces
br-mgmt     8000.0a30a9a949d9   no
root@hydrogen:~# networkctl
IDX LINK             TYPE               OPERATIONAL SETUP
  1 lo               loopback           carrier     unmanaged
  2 enp2s0           ether              routable    configured
  3 enp3s0           ether              degraded    configured
  4 enp4s0           ether              off         unmanaged
  5 enp5s0           ether              off         unmanaged
  6 br-mgmt          ether              no-carrier  configuring
  7 vlan10           ether              degraded    unmanaged

7 links listed.
```


So the bridge has no interfaces and it's in a `no-carrier` status. Why? Let's check the journal:

```
# journalctl --boot -u systemd-networkd
Jan 15 09:16:46 hydrogen systemd[1]: Started Network Service.
Jan 15 09:16:46 hydrogen systemd-networkd[1903]: br-mgmt: netdev exists, using existing without changing its parameters
Jan 15 09:16:46 hydrogen systemd-networkd[1903]: br-mgmt: Could not append VLANs: Operation not permitted
Jan 15 09:16:46 hydrogen systemd-networkd[1903]: br-mgmt: Failed to assign VLANs to bridge port: Operation not permitted
Jan 15 09:16:46 hydrogen systemd-networkd[1903]: br-mgmt: Could not set bridge vlan: Operation not permitted
Jan 15 09:16:59 hydrogen systemd-networkd[1903]: enp3s0: Configured
Jan 15 09:16:59 hydrogen systemd-networkd[1903]: enp2s0: Configured
```


The `Could not append VLANs: Operation not permitted` error is puzzling. After some searching on Google, I found a [thread from Lennart][1]:

```
 After an upgrade, systemd-networkd is broken, exactly the way descibed
> in this issue #3876[0]

Please upgrade to 231, where this should be fixed.

Lennart
```


But Ubuntu 16.04 has systemd 229:

```
# dpkg -l | grep systemd
ii  libpam-systemd:amd64                229-4ubuntu13                      amd64        system and service manager - PAM module
ii  libsystemd0:amd64                   229-4ubuntu13                      amd64        systemd utility library
ii  python3-systemd                     231-2build1                        amd64        Python 3 bindings for systemd
ii  systemd                             229-4ubuntu13                      amd64        system and service manager
ii  systemd-sysv                        229-4ubuntu13                      amd64        system and service manager - SysV links
```


I haven't found a solution for this quite yet. Keep an eye on this post and I'll update it once I know more!

 [1]: https://lists.freedesktop.org/archives/systemd-devel/2016-August/037385.html