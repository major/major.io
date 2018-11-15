---
title: Enabling VNC as a pseudo-KVM with VMWare Server
author: Major Hayden
type: post
date: 2009-03-25T01:28:59+00:00
url: /2009/03/24/enabling-vnc-as-a-pseudo-kvm-with-vmware-server/
dsq_thread_id:
  - 3642805581
categories:
  - Blog Posts
tags:
  - linux
  - mac
  - vmware
  - vnc

---
Mac users [feel a little left][1] out when it comes to [VMWare Server][2] clients. There's one for Windows and Linux, but Mac users are out of luck. Sure, you can VNC into a Linux box, use X forwarding, or use RDC to access a Windows box, but a real Mac client would really be helpful.

However, I stumbled upon some documentation that will allow you to VNC to a VMWare Server VM's main screen. It's equivalent to having a network KVM connected to the VM so you can have out-of-band management. With VMWare server 2.x, you can enable it by following these steps:

**Step 1.** Create a new VM in VMWare Server, but _don't start the VM_.

**Step 2.** SSH to the server and find your VM's .vmx file. Normally, you can find the file in a location like `/var/lib/vmware/[vmname]/[vmname].vmx`.

**Step 3.** Add the following lines to the end of the .vmx file:

<pre lang="html">RemoteDisplay.vnc.enabled = "TRUE"
RemoteDisplay.vnc.password = "vncpassword"
RemoteDisplay.vnc.port = "5900"</pre>

**Step 4.** Change the VNC port and password to values that suit your environment and then start the VM.

**DUH!** Don't set two VM's to use the same vnc port, but that should go without saying.

 [1]: http://communities.vmware.com/thread/155201
 [2]: http://www.vmware.com/products/server/
