---
aliases:
- /2017/12/15/ensuring-keepalived-starts-network-ready/
author: Major Hayden
date: 2017-12-15 21:18:37
featured_image: /wp-content/uploads/2017/12/wait.jpg
tags:
- ansible
- centos
- fedora
- linux
- network
- networking
- openstack
- systemd
title: Ensuring keepalived starts after the network is ready
---

![1]

After a recent [OpenStack-Ansible (OSA)][2] deployment on CentOS, I found that keepalived was not starting properly at boot time:

```
Keepalived_vrrp[801]: Cant find interface br-mgmt for vrrp_instance internal !!!
Keepalived_vrrp[801]: Truncating auth_pass to 8 characters
Keepalived_vrrp[801]: VRRP is trying to assign ip address 172.29.236.11/32 to unknown br-mgmt interface !!! go out and fix your conf !!!
Keepalived_vrrp[801]: Cant find interface br-mgmt for vrrp_instance external !!!
Keepalived_vrrp[801]: Truncating auth_pass to 8 characters
Keepalived_vrrp[801]: VRRP is trying to assign ip address 192.168.250.11/32 to unknown br-mgmt interface !!! go out and fix your conf !!!
Keepalived_vrrp[801]: VRRP_Instance(internal) Unknown interface !
systemd[1]: Started LVS and VRRP High Availability Monitor.
Keepalived_vrrp[801]: Stopped
Keepalived[799]: Keepalived_vrrp exited with permanent error CONFIG. Terminating
```

OSA deployments have a management bridge for traffic between containers. These containers run the OpenStack APIs and other support services. By default, this bridge is called `br-mgmt`.

The keepalived daemon is starting before NetworkManager can bring up the `br-mgmt` bridge and that is causing keepalived to fail. We need a way to tell systemd to wait on the network before bringing up keepalived.

## Waiting on NetworkManager

There is a special systemd target, `network-online.target`, that is not reached until all networking is properly configured. NetworkManager comes with a handy service called `NetworkManager-wait-online.service` that must be complete before the `network-online` target can be reached:

```bash
# rpm -ql NetworkManager | grep network-online
/usr/lib/systemd/system/network-online.target.wants
/usr/lib/systemd/system/network-online.target.wants/NetworkManager-wait-online.service
```

Start by ensuring that the `NetworkManager-wait-online` service starts at boot time:

```
systemctl enable NetworkManager-wait-online.service
```

## Using network-online.target

Next, we tell the keepalived service to wait on `network-online.target`. Bring up an editor for overriding the `keepalived.service` unit:

```
systemctl edit keepalived.service
```


Once the editor appears, add the following text:

```ini
[Unit]
Wants=network-online.target
After=network-online.target
```


Save the file in the editor and reboot the server. The keepalived service should come up successfully after NetworkManager signals that all of the network devices are online.

Learn more by reading the upstream [NetworkTarget][3] documentation.

 [1]: /wp-content/uploads/2017/12/wait.jpg
 [2]: https://github.com/openstack/openstack-ansible
 [3]: https://www.freedesktop.org/wiki/Software/systemd/NetworkTarget/