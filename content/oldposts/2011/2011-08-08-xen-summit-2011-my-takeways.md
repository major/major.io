---
title: 'Xen Summit 2011: My Takeways'
author: Major Hayden
date: 2011-08-08T12:58:54+00:00
url: /2011/08/08/xen-summit-2011-my-takeways/
dsq_thread_id:
  - 3642806613
tags:
  - cloud
  - fun
  - glusterfs
  - linux
  - performance
  - rackspace
  - sysadmin
  - xen

---
![1]

Quite a few people who couldn't make it to [Xen Summit 2011][2] this year asked me to write a post summarizing my takeaways from the event. I'm not generally one to back down from peer pressure, so read on if you're interested about the discussions at this year's Summit.

The feeling I had at last year's summit is that Xen was on the verge of losing traction in the market. Very few distributions still had Xen support going forward and much of the discussion was around the lack of dom0 support in upstream Linux kernels. Distribution vendors were hesitant to drag patches forward into modern kernels and this made it much more difficult to get Xen working for many people.

![3]

This year was quite different. The number of attendees was up, the [venue was much better][4], and there was an obvious buzz of energy in the room. As many of the presenters noted, this excitement stemmed from the [upstream dom0 support in Linux 3.0][5]. This inclusion is a huge win and it helps to drive Xen forward since the developers don't have to worry about dragging patches forward. They can focus on improving performance, adding features, and tightening security.

Many of the discussions this year focused on security and performance. Ian Pratt discussed Xen's ability to view memory pages of virtual machines via an API to detect malware running inside the instance. Memory pages could be identified and marked as not executable or applications could be triggered when a VM attempts to touch a particular memory page. Also, the whole VM could be frozen if needed.

There's also a big push to bring code out of the dom0 and push it into utility VM's. Driver domains could manage the network or I/O infrastructure and this would further reduce the amount of privileged code actively running in dom0. There is already very little code required for the Xen hypervisor itself (much much less than the Linux kernel - I'm looking at you, [KVM][6]) and this reduces the attack surface for potential compromises of the hypervisor. Some projects even aim to restart driver domains multiple times per minute to ensure that any malicious code injected into those virtual machines can't exist for long periods.

Pradeep Vincent from [Amazon][7] talked about how Amazon uses Xen and the pain points they have with its current architecture. Much of his discussion was around scaling problems (and we see many of the same issues at [Rackspace][8]). Higher performance could easily be gained by multi-threaded operations in dom0 when attaching block devices and creating virtual network interfaces. He also saw some areas for performance gains in the pvops I/O code.

Quite a few of the talks centered on the ARM architecture and what Xen is able to do on those systems after [Samsung published their port in 2008][9]. HVM is on the way for ARM and it might even show up in Xen 4.2. Some demos of Xen on mobile phones from Samsung were amazing. They showed how an attacker could compromise the web browser on the phone with a keylogger, but that application was running in a VM. Once the user switched back to the phone's main menu, the keylogger couldn't access the keystrokes any longer. After that, a simple close of the browser killed the VM and destroyed the malicious code.

Xen 4.2 should be available in early 2012 and the feature list is staggering. Improvements to libxenlight, pvops performance (even in HVM), and guest memory sharing should be available with the new release. Nested virtualization (run a hypervisor inside a hypervisor) is also coming in Xen 4.2 and I'm sure Xzibit will be a huge fan. This should streamline hypervisor testing, allow for embedded hypervisor options and extend the capabilities of client hypervisors. Remus should be available in 4.2 as well, but it might be marked as experimental. OVMF will be added as a BIOS option for UEFI (along with the standard SeaBIOS) and this should allow for Mac OS X guests. UEFI allows Windows to boot faster since it switches to PV mode sooner and it allows for simpler platform certification for software vendors.

![10]

Mike McClurg's presentation on [XCP][11] was pretty important to me since Rackspace is a big consumer of [XenServer][12]. If you're not familiar with XCP, it's basically open-source XenServer which runs on bleeding edge (and sometimes unstable) components. XCP 1.5 and XenServer 6 should be available in November with Xen 4.1 and Linux 2.6.32. GPU passthrough, up to 1TB RAM, and disaster recovery will be available. Another goal for the XCP team is to work closely with OpenStack via Project Olympus. Mike's vision is to have XCP become the configuration of choice for open source clouds. [Project Kronos][13] was also extremely interesting. It's essentially XCP's XenAPI stack running on Debian and Ubuntu. You'd be able to install either OS on a physical server and run XCP's services on it for a fully OSS hypervisor.

Konrad Wilk gave an update on Linux pvops and it appears there is a shift to get Xen working well on a desktop. This includes 3D graphics support, S3/hibernate capabilities and various bug fixes. There's also a push to get PV functionality into HVM and get HVM functionality into PV. Driver/device domains were discussed again in Patrick Kolp's talk and he had plenty of graphs showing performance changes when regularly restarting device domains. The performance dips were almost negligible with 10 second restarts and the security gains were significant.

There were several other great presentations on other topics like [GlusterFS][14], [OpenStack Nova][15], and [Linpicker][16] (from the NSA!). If these types of things interests you, keep your eyes peeled for Xen Summit 2012 next year. The [weather in the bay area][17] is well worth the trip. ;)

 [1]: /wp-content/uploads/2011/08/xensummit_na11_small.png
 [2]: http://xen.org/community/xensummit.html
 [3]: /wp-content/uploads/2011/08/Photo-Aug-01-5-54-05-PM.jpeg
 [4]: http://www.citrix.com/tv/#videos/4386
 [5]: http://blog.xen.org/index.php/2011/06/14/linux-3-0-how-did-we-get-initial-domain-dom0-support-there/
 [6]: http://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine
 [7]: http://aws.amazon.com/
 [8]: http://www.rackspace.com
 [9]: http://www.xen.org/products/xen_arm.html
 [10]: /wp-content/uploads/2011/08/OpenStackLogo_270x279.jpg
 [11]: http://www.xen.org/products/cloudxen.html
 [12]: http://www.citrix.com/English/ps2/products/product.asp?contentID=683148
 [13]: http://blog.xen.org/index.php/2011/07/22/project-kronos/
 [14]: http://www.gluster.org/
 [15]: http://nova.openstack.org/
 [16]: http://cgit.freedesktop.org/~ewalsh/linpicker/
 [17]: http://weatherspark.com/#!dashboard;q=santa+clara,+ca
