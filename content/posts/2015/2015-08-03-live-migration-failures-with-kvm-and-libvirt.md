---
title: Live migration failures with KVM and libvirt
author: Major Hayden
date: 2015-08-03T13:13:30+00:00
url: /2015/08/03/live-migration-failures-with-kvm-and-libvirt/
dsq_thread_id:
  - 3998873295
tags:
  - fedora
  - kvm
  - libvirt
  - qemu
  - virtualization

---
I decided to change some of my infrastructure back to KVM again, and the overall experience has been quite good in Fedora 22. Using libvirt with KVM is a breeze and the virt-manager tools make it even easier. However, I ran into some problems while trying to migrate virtual machines from one server to another.

### The error

```
# virsh migrate --live --copy-storage-all bastion qemu+ssh://root@192.168.250.33/system
error: internal error: unable to execute QEMU command 'drive-mirror': Failed to connect socket: Connection timed out
```


That error message wasn't terribly helpful. I started running through my usual list of checks:

  * _Can the hypervisors talk to each other?_ Yes, iptables is disabled.
  * _Are ssh keys configured?_ Yes, verified.
  * _What about ssh host keys being accepted on each side?_ Both sides can ssh without interaction.
  * _SELinux?_ No AVC's logged.
  * _Libvirt logs?_ Nothing relevant in libvirt's qemu logs.
  * _Filesystem permissions for libvirt's directories?_ Identical on both sides.
  * _Libvirt daemon running on both sides?_ Yes.

I was pretty confused at this point. A quick Google search didn't reveal too many relevant issues, but I did find a [Red Hat Bug from 2013][1] that affected RHEL 7. The issue in the bug was that libvirt wasn't using the right ports to talk between servers and those packets were being dropped by iptables. My iptables rules were empty.

### Debug time

I ran the same command with `LIBVIRT_DEBUG=1` at the front:

```
 debug.log
```


After scouring the pages and pages of output, I couldn't find anything useful.

### Eureka!

I spotted an error message briefly in virt-manager or the debug logs that jogged my brain to think about a potential problem: hostnames. Both hosts had a fairly bare `/etc/hosts` file without IP/hostname pairs for each hypervisor. After editing both servers' `/etc/hosts` file to include the short and full hostnames for each hypervisor, I tested the live migration one more time.

**Success!**

The migration went off without a hitch in virt-manager and via the `virsh` client. I migrated several VM's, including the one running this site, with no noticeable interruption.

 [1]: https://bugzilla.redhat.com/show_bug.cgi?id=1025699
