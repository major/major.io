---
aliases:
- /2015/08/28/build-a-high-performance-kvm-hypervisor-on-rackspaces-onmetal-servers/
author: Major Hayden
date: 2015-08-28 14:00:16
tags:
- fedora
- kvm
- networking
- rackspace
- raid
- virtualization
title: Build a high performance KVM hypervisor on Rackspace’s OnMetal servers
---

I received some good feedback about [my post on systemd-networkd and bonded interfaces][1] on [Rackspace's OnMetal servers][2], and I decided to write about another use case. Recent product updates allow you to [attach a Cloud Block Storage volume][3], and this opens up quite a few new possibilities for deployments.

So why not create a high-performance KVM hypervisor on an OnMetal server? Let's do this.

## Disclaimer

**_WHOA THERE._** These are amazing servers and because of that, they're priced much differently than Cloud Servers are. Be sure to review the pricing for [OnMetal][2] and [Cloud Block Storage][4] before going through this guide. **Don't end up with an unexpected bill by building one of these servers and forgetting to destroy it.**

## Building the server

We can build our server using command line tools. One of my tools, [supernova][5], makes this quite easy. My IAD environment is called `prodiad` and I can boot an OnMetal server like this:

```
supernova prodiad boot \
  --flavor onmetal-memory1 \
  --image 4c361a4a-51b4-4e29-8a35-3b0e25e49ee1 \
  --key_name personal_servers \
  --poll \
  kvm-onmetal
```

In the command above, I've built an OnMetal Memory server. I'll end up with some hardware like this:

  * Dual Intel Xeon E5-2630 v2 2.6Ghz
  * 12 cores total
  * 512GB RAM
  * 10Gbps connectivity
  * 32GB disk

Everything looks amazing except for the storage &#8212; but we'll fix that soon. I've also built the server with Fedora 22 and provided my public ssh key.

Wait a few minutes after running the supernova command and you should be back to a prompt. Verify that your new OnMetal server is pinging, but keep in mind it may still be in the process of booting up or configuring itself.

## Adding storage

Getting additional storage for an OnMetal server is done in two steps: provisioning the LUN and attaching it to the host. This is a bit easier in Cloud Servers since the actual attachment is done behind the scenes. You end up with a disk that attaches itself to the virtual machine at the hypervisor layer. OnMetal is a little different, but the process is still very straightforward.

Let's start by making four 100GB SSD volumes. We will eventually put these into a RAID 10 volume.

```shell
for i in `seq 1 4`; do
    supernova prodiad volume-create \
      --display-name onmetal-kvm-${i} \
      --volume-type SSD \
      100
done
```

We can list our new volumes:

```
$ supernova prodiad volume-list
+--------------------------------------+-----------+---------------+------+-------------+-------------+
| ID                                   | Status    | Display Name  | Size | Volume Type | Attached to |
+--------------------------------------+-----------+---------------+------+-------------+-------------+
| 0beb1f81-eb04-4aca-9b14-c952f9eb81e2 | available | onmetal-kvm-4 | 100  | SSD         |             |
| 83b9d6d9-e7eb-4b53-9342-fa2fd3670bb4 | available | onmetal-kvm-3 | 100  | SSD         |             |
| a593cbbe-089f-4ede-81f4-003717b2309f | available | onmetal-kvm-2 | 100  | SSD         |             |
| 2c51e09f-d984-4de5-8852-c0f9c6176e00 | available | onmetal-kvm-1 | 100  | SSD         |             |
+--------------------------------------+-----------+---------------+------+-------------+-------------+
```

It's now time to attach our volumes to our OnMetal server. Let's get our OnMetal server's UUID:

```
$ supernova prodiad list --name kvm-onmetal --minimal
[SUPERNOVA] Running nova against prodiad...
+--------------------------------------+-------------+
| ID                                   | Name        |
+--------------------------------------+-------------+
| 6a80d0b9-ce3e-4693-bedb-d843fea7cb0b | kvm-onmetal |
+--------------------------------------+-------------+
```

Now we're ready to attach the volumes:

```
ONMETAL_UUID=6a80d0b9-ce3e-4693-bedb-d843fea7cb0b
supernova prodiad volume-attach $ONMETAL_UUID 2c51e09f-d984-4de5-8852-c0f9c6176e00
supernova prodiad volume-attach $ONMETAL_UUID a593cbbe-089f-4ede-81f4-003717b2309f
supernova prodiad volume-attach $ONMETAL_UUID 83b9d6d9-e7eb-4b53-9342-fa2fd3670bb4
supernova prodiad volume-attach $ONMETAL_UUID 0beb1f81-eb04-4aca-9b14-c952f9eb81e2
```

Let's log into the OnMetal server and get it ready. Install the `iscsi-initator-utils` package and set up the services:

```
dnf -y install iscsi-initiator-utils
systemctl enable iscsid
systemctl start iscsid
```

Our iSCSI IQN data is in our OnMetal server's metadata. Grab your metadata JSON with this command:

```
supernova prodiad show 6a80d0b9-ce3e-4693-bedb-d843fea7cb0b | grep metadata
```

If you copy/paste the JSON data into a file, you can use Python to make the JSON easier to read:

```
cat iscsi_metadata.json | python -m json.tool
```

Start by putting your server's initiator name into a file. It should be called `initiator_name` in the JSON data.

```
echo InitiatorName=iqn.2008-10.org.openstack:735f1804-bf47-4b28-b9fc-cbff3995635e > /etc/iscsi/initiatorname.iscsi
```

Do the iSCSI logins for each \`target\_iqn\` and \`target\_portal\` in your JSON output. It should look something like this each time:

```
# iscsiadm -m discovery --type sendtargets --portal $TARGET_PORTAL
# iscsiadm -m node --targetname=$TARGET_IQN --portal $TARGET_PORTAL --login
```

When you're all done, you should have four new disks:

```
# ls /dev/disk/by-path/
ip-10.190.141.11:3260-iscsi-iqn.2010-11.com.rackspace:a593cbbe-089f-4ede-81f4-003717b2309f-lun-0
ip-10.190.141.44:3260-iscsi-iqn.2010-11.com.rackspace:0beb1f81-eb04-4aca-9b14-c952f9eb81e2-lun-0
ip-10.190.142.17:3260-iscsi-iqn.2010-11.com.rackspace:2c51e09f-d984-4de5-8852-c0f9c6176e00-lun-0
ip-10.190.143.103:3260-iscsi-iqn.2010-11.com.rackspace:83b9d6d9-e7eb-4b53-9342-fa2fd3670bb4-lun-0
```

## Building the RAID volume

We can build the raid volume using the paths from above to prevent against device name changes later. Let's make a RAID 10 volume:

```
dnf -y install mdadm
mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/disk/by-path/*
```

Check the status of the new RAID volume:

```
# cat /proc/mdstat
Personalities : [raid10]
md0 : active raid10 sdd[3] sdc[2] sdb[1] sde[0]
      209584128 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
      [>....................]  resync =  0.7% (1534400/209584128) finish=15.8min speed=219200K/sec
```

Come on, our storage volumes are faster than that. Let's speed it up a bit:

```
# sysctl -w dev.raid.speed_limit_max=99999999
# cat /proc/mdstat
Personalities : [raid10]
md0 : active raid10 sdd[3] sdc[2] sdb[1] sde[0]
      209584128 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
      [====>................]  resync = 21.1% (44229312/209584128) finish=2.9min speed=925564K/sec
```

That's more like it. Let's put a XFS filesystem on the volume and get it mounted:

```
dnf -y install xfsprogs
mkfs.xfs /dev/md0
mkdir /mnt/raid
echo "/dev/md0 /mnt/raid xfs defaults,noatime 0 1" >> /etc/fstab
mount -a
```

## Getting KVM going

It's time to get packages updated and installed:

```
dnf -y upgrade
dnf -y install libvirt libvirt-daemon* virt-install virt-manager xorg-x11-xauth gnome-icon-theme gnome-themes-standard dejavu*
systemctl start libvirtd
systemctl enable libvirtd
```

We can create a qcow volume and begin installing Fedora into a virtual machine:

```
qemu-img create -f qcow2 /mnt/raid/fedora-kvm.qcow2 20G
virt-install --name=fedora-kvm --ram=16384 \
    --vcpus=4 --os-variant=fedora21 --accelerate \
    --hvm --network network=default \
    --disk /mnt/raid/fedora-kvm.qcow2 \
    --location http://iad.mirror.rackspace.com/fedora/releases/22/Server/x86_64/os/ \
    --noautoconsole --graphics vnc --autostart
```

Logout and then ssh to the server again, this time with `-Y` for X forwarding. Run `virt-manager` and verify that the VM is running.

![6]

Double-click on the virtual machine listed there and the anaconda installer should be on the screen.

![installer_screenshot]

</a>

Let the installation complete and you'll have a KVM virtual machine ready to roll!

## Additional thoughts

Obviously, this is a very manual process. It could be automated with scripts, or an orchestration framework, like Ansible. In addition, deployment of virtual machines could be automated with OpenStack. However, my goal here was to demonstrate a new use case for OnMetal servers. I'll add the automation to my long list of to-do's.

 [1]: /2015/08/21/using-systemd-networkd-with-bonding-on-rackspaces-onmetal-servers/
 [2]: http://www.rackspace.com/en-us/cloud/servers/onmetal
 [3]: http://www.rackspace.com/knowledge_center/article/attach-a-cloud-block-storage-volume-to-an-onmetal-server
 [4]: http://www.rackspace.com/cloud/block-storage
 [5]: https://github.com/major/supernova
 [6]: /wp-content/uploads/2015/08/virt-manager-listing.png
 [installer_screenshot]: /wp-content/uploads/2015/08/onmetal-kvm-vm.png