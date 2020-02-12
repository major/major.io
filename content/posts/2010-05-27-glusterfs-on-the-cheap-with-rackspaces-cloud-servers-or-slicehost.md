---
title: GlusterFS on the cheap with Rackspace’s Cloud Servers or Slicehost
author: Major Hayden
type: post
date: 2010-05-28T00:34:10+00:00
url: /2010/05/27/glusterfs-on-the-cheap-with-rackspaces-cloud-servers-or-slicehost/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642806159
categories:
  - Blog Posts
tags:
  - command line
  - filesystem
  - glusterfs
  - high availability
  - rackspace
  - storage
  - sysadmin

---
_<b style="color: red">NOTE:</b> This post is out of date and is relevant only for GlusterFS 2.x._

* * *High availability is certainly not a new concept, but if there's one thing that frustrates me with high availability VM setups, it's storage. If you don't mind going active-passive, you can set up

[DRBD][1], toss your favorite filesystem on it, and you're all set.</p>

If you want to go active-active, or if you want multiple nodes active at the same time, you need to use a clustered filesystem like [GFS2][2], [OCFS2][3] or [Lustre][4]. These are certainly good options to consider but they're not trivial to implement. They usually rely on additional systems and scripts to provide reliable [fencing][5] and [STONITH][6] capabilities.

What about the rest of us who want multiple active VM's with simple replicated storage that doesn't require any additional elaborate systems? This is where [GlusterFS][7] really shines. GlusterFS can ride on top of whichever filesystem you prefer, and that's a huge win for those who want a simple solution. However, that means that it has to use [fuse][8], and that will limit your performance.

**Let's get this thing started!**

Consider a situation where you want to run a WordPress blog on two VM's with load balancers out front. You'll probably want to use GlusterFS's replicated volume mode (RAID 1-ish) so that the same files are on both nodes all of the time. To get started, build two small Slicehost slices or Rackspace Cloud Servers. I'll be using Fedora 13 in this example, but the instructions for other distributions should be very similar.

First things first &#8212; be sure to set a new root password and update all of the packages on the system. This should go without saying, but it's important to remember. We can clear out the default iptables ruleset since we will make a customized set later:

<pre lang="html"># iptables -F
# /etc/init.d/iptables save
iptables: Saving firewall rules to /etc/sysconfig/iptables:        [  OK  ]</pre>

GlusterFS communicates over the network, so we will want to ensure that traffic only moves over the private network between the instances. We will need to add the private IP's and a special hostname for each instance to `/etc/hosts` on both instances. I'll call mine `gluster1` and `gluster2`:

<pre lang="html">10.xx.xx.xx gluster1
10.xx.xx.xx gluster2</pre>

You're now ready to install the required packages on both instances:

<pre lang="html">yum install glusterfs-client glusterfs-server glusterfs-common glusterfs-devel</pre>

Make the directories for the GlusterFS volumes on each instance:

<pre lang="html">mkdir -p /export/store1</pre>

We're ready to make the configuration files for our storage volumes. Since we want the same files on each instance, we will use the `--raid 1` option. **This only needs to be run on the first node:**

<pre lang="html"># glusterfs-volgen --name store1 --raid 1 gluster1:/export/store1 gluster2:/export/store1
Generating server volfiles.. for server 'gluster2'
Generating server volfiles.. for server 'gluster1'
Generating client volfiles.. for transport 'tcp'</pre>

Once that's done, you'll have four new files:

  * `booster.fstab` &#8211; you won't need this file
  * `gluster1-store1-export.vol` &#8211; server-side configuration file for the first instance
  * `gluster2-store1-export.vol` &#8211; server-side configuration file for the second instance
  * `store1-tcp.vol` &#8211; client side configuration file for GlusterFS clients

Copy the `gluster1-store1-export.vol` file to `/etc/glusterfs/glusterfsd.vol` on your first instance. Then, copy `gluster2-store1-export.vol` to `/etc/glusterfs/glusterfsd.vol` on your second instance. The `store1-tcp.vol` should be copied to `/etc/glusterfs/glusterfs.vol` on both instances.

At this point, you're ready to start the GlusterFS servers on each instance:

<pre lang="html">/etc/init.d/glusterfsd start</pre>

You can now mount the GlusterFS volume on both instances:

<pre lang="html">mkdir -p /mnt/glusterfs
glusterfs /mnt/glusterfs/</pre>

You should now be able to see the new GlusterFS volume in both instances:

<pre lang="html"># df -h /mnt/glusterfs
Filesystem            Size  Used Avail Use% Mounted on
/etc/glusterfs/glusterfs.vol
                      9.4G  831M  8.1G  10% /mnt/glusterfs</pre>

As a test, you can create a file on your first instance and verify that your second instance can read the data:

<pre lang="html">[root@gluster1 ~]# echo "We're testing GlusterFS" > /mnt/glusterfs/test.txt
.....
[root@gluster2 ~]# cat /mnt/glusterfs/test.txt
We're testing GlusterFS</pre>

If you remove that file on your second instance, it should disappear from your first instance as well.

Obviously, this is a very simple and basic implementation of GlusterFS. You can increase performance by making dedicated VM's just for serving data and you can adjust the default performance options when you mount a GlusterFS volume. Limiting access to the GlusterFS servers is also a good idea.

If you want to read more, I'd recommend reading the [GlusterFS Technical FAQ][9] and the [GlusterFS User Guide][10].

* * *

**Thank you for your e-mails!** I'll be expanding on this post later with some sample benchmarks and additional tips/tricks, so please stay tuned.</p>

 [1]: http://en.wikipedia.org/wiki/Drbd
 [2]: http://en.wikipedia.org/wiki/Global_File_System
 [3]: http://en.wikipedia.org/wiki/OCFS
 [4]: http://en.wikipedia.org/wiki/Lustre_(file_system)
 [5]: http://en.wikipedia.org/wiki/Fencing_(computing)
 [6]: http://en.wikipedia.org/wiki/STONITH
 [7]: http://en.wikipedia.org/wiki/GlusterFS
 [8]: http://en.wikipedia.org/wiki/Filesystem_in_Userspace
 [9]: http://www.gluster.com/community/documentation/index.php/GlusterFS_Technical_FAQ
 [10]: http://www.gluster.com/community/documentation/index.php/GlusterFS_User_Guide
