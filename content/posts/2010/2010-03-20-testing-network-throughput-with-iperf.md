---
title: Testing network throughput with iperf
author: Major Hayden
date: 2010-03-20T21:38:07+00:00
url: /2010/03/20/testing-network-throughput-with-iperf/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642806092
tags:
  - command line
  - linux
  - network

---
When you need to measure network throughput and capacity, I haven't found a simpler solution than [iperf][1]. There isn't [much to say][2] about the operation of iperf &#8212; it's a very simple application.

In short, iperf can be installed on two machines within your network. You'll run one as a server, and one as a client. On the server side, simply run:

<pre lang="html">iperf -s</pre>

On the client side, run:

<pre lang="html">iperf -c [server_ip]</pre>

The client side will try to shove TCP packets through the network interface as quickly as possible for a period of 10 seconds by default. Once that's complete, you'll see a report on the server and client that will look like this:

<pre lang="html">$ iperf -c 192.168.10.10
------------------------------------------------------------
Client connecting to 192.168.10.10, TCP port 5001
TCP window size: 65.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.10.30 port 53345 connected with 192.168.10.10 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  37.9 MBytes  31.8 Mbits/sec
</pre>

The previous test was run over an 802.11n network between a wired and wireless device. The [typical downlink][3] for an 802.11n network is about 40Mbit/s, so it's obvious that my home network could use an adjustment.

You can also run bidirectional tests from the client either at the same time (`-d` flag) or one after the other (`-r` flag). The server side will keep running until you stop it, so you can leave it running and run tests from multiple locations over time. You can daemonize the server end if that makes things easier.

For the full list of options, refer to [iperf's man page][4].

 [1]: http://sourceforge.net/projects/iperf/
 [2]: http://en.wikipedia.org/wiki/Iperf
 [3]: http://en.wikipedia.org/wiki/Comparison_of_wireless_data_standards#Throughput
 [4]: http://staff.science.uva.nl/~jblom/gigaport/tools/man/iperf.html
