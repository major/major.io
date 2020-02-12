---
title: Configure static IP addresses for Project Atomic’s KVM image
author: Major Hayden
type: post
date: 2014-04-23T15:14:39+00:00
url: /2014/04/23/configure-static-ip-addresses-for-project-atomics-kvm-image/
dsq_thread_id:
  - 3642807478
categories:
  - Blog Posts
tags:
  - docker
  - fedora
  - network
  - sysadmin
  - virtualization

---
Amid all of the Docker buzz at the Red Hat Summit, [Project Atomic][1] was launched. It's a minimalistic Fedora 20 image with a [few tweaks][2], including [rpm-ostree][3] and [geard][4].

There are [great instructions][5] on the site for firing up a test instance under KVM but my test server doesn't have a DHCP server on its network. You can use Project Atomic with static IP addresses fairly easily:

Create a one-line `/etc/sysconfig/network`:

```ini
NETWORKING=yes
```

Drop in a basic network configuration into `/etc/sysconfig/network-scripts/ifcfg-eth0`:

```ini
DEVICE=eth0
IPADDR=10.127.92.32
NETMASK=255.255.255.0
GATEWAY=10.127.92.1
ONBOOT=yes
```

All that's left is to set DNS servers and a hostname:

```
echo "nameserver 8.8.8.8" > /etc/resolv.conf
hostnamectl set-hostname myatomichost.example.com
```

Bring up the network interface:

```
ifup eth0
```

Of course, you could do all of this via the `nmcli` tool if you prefer to go that route.

 [1]: http://www.projectatomic.io/
 [2]: http://www.projectatomic.io/docs/gettingstarted/
 [3]: http://rpm-ostree.cloud.fedoraproject.org/#/
 [4]: https://openshift.github.io/geard/
 [5]: http://www.projectatomic.io/download/
