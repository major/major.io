---
title: Supermicro X9SCI/X9SCA server does a shutdown rather than a reboot
author: Major Hayden
date: 2013-06-03T14:45:34+00:00
url: /2013/06/03/supermicro-x9scix9sca-server-does-a-shutdown-rather-than-a-reboot/
dsq_thread_id:
  - 3642807305
tags:
  - centos
  - command line
  - fedora
  - linux
  - red hat
  - sysadmin

---
Most of my websites run on a pair of Supermicro servers that I purchased from [Silicon Mechanics][1] (and I can't say enough good things about them and their servers). One problem that kept cropping up was that the servers would become unresponsive during a reboot. If I issued the `reboot` command in Linux, the machine would begin the reboot process, power off, and remain powered off.

Needless to say, this is highly annoying.

The only way to bring the machine back was to use ipmitool on my other server or access the IPMI/iKVM interface on the downed server. I tested Fedora 15 through 19 and confirmed the issue in each OS. Finally, I installed CentOS 6 and the problem disappeared. The servers would reboot and come back online as expected.

Fast forward to this evening. I discovered a [helpful forum thread][2] where users were discussing a similar problem on a X9SCA-F Supermicro board. The fix was to blacklist a kernel module like this:

```
 /etc/modprobe.d/blacklist.conf
```


I tried to `rmmod mei` and reboot, but the machine stayed powered off again. When I powered it back on with the module blacklisted from the start, I found that I could reboot normally and the server would boot up again. The module is from Intel:

```
# modinfo mei | grep desc
summary:    Intel(R) Management Engine Interface
```


The Intel Management Engine is a BIOS extension that enables Intel Active Management Technology (AMT). Intel [has a PDF][3] that gives an overview of AMT:

> Intel® Active Management Technology (Intel® AMT) is a capability embedded in Intel-based platforms that enhances the ability of IT organizations to manage enterprise computing facilities. Intel AMT operates independently of the platform processor and operating system. Remote platform management applications can access Intel AMT securely, even when the platform is turned off, as long as the platform is connected to line power and to a network. Independent software vendors (ISVs) can build applications that take advantage of the features of Intel AMT using the application programming interface (API).

That's a mouthful.

It essentially allows you to manage large amounts of hardware and keep an inventory. You can also pull event logs from the machine even if it's powered off. Applications running within the OS on the server can give data to the AMT interface that allows administrators to retrieve the data without needing access to the OS.

The blacklisted module hasn't affected the server negatively (as far as I can tell).

 [1]: http://www.siliconmechanics.com/
 [2]: http://ubuntuforums.org/showthread.php?t=2024096
 [3]: http://software.intel.com/sites/default/files/m/2/3/8/9/c/17992-intel_amt_overview.pdf
