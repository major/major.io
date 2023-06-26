---
aliases:
- /2011/06/05/measure-traffic-flows-with-mikrotiks-routeros-and-ntop-on-fedora-15/
author: Major Hayden
date: 2011-06-05 14:58:26
tags:
- fedora
- linux
- mikrotik
- networking
- ntop
title: Measure traffic flows with Mikrotik’s RouterOS and ntop on Fedora 15
---

It's no secret that I'm a big fan of the [RouterBoard][1] network devices paired with [Mikrotik's RouterOS][2]. I discovered today that these devices offer Cisco NetFlow-compatible statistics gathering which can be directed to a Linux box running [ntop][3]. Mikrotik calls it &#8220;traffic flow&#8221; and it's much more efficient than setting up a mirrored or spanned port and then using ntop to dump traffic on that interface.

These instructions are for Fedora 15, but they should be pretty similar on most other Linux distributions. Install ntop first:

<pre lang="html">yum -y install ntop</pre>

Adjust `/etc/ntop.conf` so that ntop listens on something other than localhost:

<pre lang="html"># limit ntop to listening on a specific interface and port
--http-server 0.0.0.0:3000 --https-server 0.0.0.0:3001
</pre>

I had to comment out the `sched_yield()` option to get ntop to start:

<pre lang="html"># Under certain circumstances, the sched_yield() function causes the ntop web
# server to lock up.  It shouldn't happen, but it does.  This option causes
# ntop to skip those calls, at a tiny performance penalty.
# --disable-schedyield
</pre>

Set an admin password for ntop:

<pre lang="html">ntop --set-admin-password</pre>

Once you set the password, you may need to press CTRL-C to get back to a prompt in some ntop versions.

Start ntop:

<pre lang="html">/etc/init.d/ntop start</pre>

Open a web browser and open http://example.com:3000 to access the ntop interface. Roll your mouse over the **Plugins** menu, then **NetFlow**, and then click **Activate**. Roll your mouse over the **Plugins** menu again, then **NetFlow**, and then click **Configure**. Click **Add NetFlow Device** and fill in the following:

  * Type &#8220;Mikrotik&#8221; in the **NetFlow Device** section and click **Set Interface Name**.
  * Type 2055 in the **Local Collector UDP Port** section and click **Set Port**.
  * Type in your router's IP/netmask in the **Virtual NetFlow Interface Network Address** section and click **Set Interface Address**.

Enabling traffic flow on the Mikrotik can be done with just two configuration lines:

<pre lang="html">/ip traffic-flow
set enabled=yes interfaces=all
/ip traffic-flow target
add address=192.168.10.65:2055 disabled=no version=5</pre>

Wait about a minute and then try reviewing some of the data in the ntop interface. Depending on the amount of traffic on your network, you might see data in as little as 10-15 seconds.

 [1]: http://www.routerboard.com/
 [2]: http://www.mikrotik.com/software.html
 [3]: http://www.ntop.org/