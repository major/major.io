---
title: Dual-primary DRBD with OCFS2
author: Major Hayden
type: post
date: 2011-02-14T02:12:58+00:00
url: /2011/02/13/dual-primary-drbd-with-ocfs2/
dsq_thread_id:
  - 3642806535
categories:
  - Blog Posts
tags:
  - centos
  - cluster
  - command line
  - fedora
  - filesystem
  - high availability
  - linux
  - ocfs2
  - red hat
  - storage
  - sysadmin

---
As promised in one of my [previous posts][1] about dual-primary DRBD and OCFS2, I've compiled a step-by-step guide for Fedora. These instructions should be somewhat close to what you would use on CentOS or Red Hat Enterprise Linux. However, CentOS and Red Hat don't provide some of the packages needed, so you will need to use other software repositories like [RPMFusion][2] or [EPEL][3].

In this guide, I'll be using two Fedora 14 instances in the [Rackspace Cloud][4] with separate public and private networks. The instances are called server1 and server2 to make things easier to follow.

**NOTE: All of the instructions below should be done on both servers unless otherwise specified.**

* * *First, we need to set up DRBD with two primary nodes. I'll be using loop files for this setup since I don't have access to raw partitions.</p>

<pre lang="html">yum -y install drbd-utils
dd if=/dev/zero of=/drbd-loop.img bs=1M count=1000
</pre>

Put this [loop file initialization init script][5] in /etc/init.d/loop-for-drbd and finish setting it up:

<pre lang="html">chmod a+x /etc/init.d/loop-for-drbd
chkconfig loop-for-drbd on
/etc/init.d/loop-for-drbd start
</pre>

Place this DRBD resource file in `/etc/drbd.d/r0.res`. Be sure to adjust the server names and IP addresses for your servers.

<pre lang="html">resource r0 {
	meta-disk internal;
	device /dev/drbd0;
	disk /dev/loop7;

	syncer { rate 1000M; }
        net {
                allow-two-primaries;
                after-sb-0pri discard-zero-changes;
                after-sb-1pri discard-secondary;
                after-sb-2pri disconnect;
        }
	startup { become-primary-on both; }

	on server1 { address 10.181.76.0:7789; }
	on server2 { address 10.181.76.1:7789; }
}
</pre>

The `net` section is telling DRBD to do the following:

  * _allow-two-primaries_ &#8211; Generally, DRBD has a primary and a secondary node. In this case, we will allow both nodes to have the filesystem mounted at the same time. **Do this only with a clustered filesystem. If you do this with a non-clustered filesystem like ext2/ext3/ext4 or reiserfs, _you will have data corruption_. Seriously!**
  * _after-sb-0pri discard-zero-changes_ &#8211; DRBD detected a split-brain scenario, but none of the nodes think they're a primary. DRBD will take the newest modifications and apply them to the node that didn't have any changes.
  * _after-sb-1pri discard-secondary_ &#8211; DRBD detected a split-brain scenario, but one node is the primary and the other is the secondary. In this case, DRBD will decide that the secondary node is the victim and it will sync data from the primary to the secondary automatically.
  * _after-sb-2pri disconnect_ &#8211; DRBD detected a split-brain scenario, but it can't figure out which node has the right data. It tries to protect the consistency of both nodes by disconnecting the DRBD volume entirely. You'll have to tell DRBD which node has the valid data in order to reconnect the volume. **Use extreme caution if you find yourself in this scenario.**

If you'd like to read about DRBD split-brain behavior in more detail, [review the documentation][6].

I generally turn off the usage reporting functionality in DRBD within `/etc/drbd.d/global_common.conf`:

<pre lang="html">global {
	usage-count no;
}
</pre>

Now we can create the volume and start DRBD:

<pre lang="html">drbdadm create-md r0
/etc/init.d/drbd start && chkconfig drbd on
</pre>

You may see some errors thrown about having two primaries but neither are up to date. That can be fixed by running the following command on the **primary node only**:

<pre lang="html">drbdsetup /dev/drbd0 primary -o</pre>

If you run `cat /proc/drbd` on the secondary node, you should see the DRBD sync running:

<pre lang="html">version: 8.3.8 (api:88/proto:86-94)
srcversion: 299AFE04D7AFD98B3CA0AF9
 0: cs:SyncTarget ro:Secondary/Primary ds:Inconsistent/UpToDate C r----
    ns:0 nr:210272 dw:210272 dr:0 al:0 bm:12 lo:1 pe:2682 ua:0 ap:0 ep:1 wo:b oos:813660
        [===>................] sync'ed: 20.8% (813660/1023932)K queue_delay: 0.0 ms
        finish: 0:01:30 speed: 8,976 (6,368) want: 1024,000 K/sec
</pre>

Before you go any further, wait for the DRBD sync to fully finish. When it completes, it should look like this:

<pre lang="html">version: 8.3.8 (api:88/proto:86-94)
srcversion: 299AFE04D7AFD98B3CA0AF9
 0: cs:Connected ro:Secondary/Primary ds:UpToDate/UpToDate C r----
    ns:0 nr:1023932 dw:1023932 dr:0 al:0 bm:63 lo:0 pe:0 ua:0 ap:0 ep:1 wo:b oos:0
</pre>

Now, **on the secondary node only** make it a primary node as well:

<pre lang="html">drbdadm primary r0</pre>

You should see this on the secondary node if you've done everything properly:

<pre lang="html">version: 8.3.8 (api:88/proto:86-94)
srcversion: 299AFE04D7AFD98B3CA0AF9
 0: cs:Connected ro:Primary/Primary ds:UpToDate/UpToDate C r----
    ns:1122 nr:1119 dw:2241 dr:4550 al:2 bm:1 lo:0 pe:0 ua:0 ap:0 ep:1 wo:b oos:0
</pre>

We're now ready to move on to configuring OCFS2. Only one package is needed:

<pre lang="html">yum -y install ocfs2-tools</pre>

Ensure that you have your servers and their private IP addresses in `/etc/hosts` before proceeding. Create the `/etc/ocfs2` directory and place the following configuration in `/etc/ocfs2/cluster.conf` (adjust the server names and IP addresses):

<pre lang="html">cluster:
	node_count = 2
	name = web

node:
	ip_port = 7777
	ip_address = 10.181.76.0
	number = 1
	name = server1
	cluster = web

node:
	ip_port = 7777
	ip_address = 10.181.76.1
	number = 2
	name = server2
	cluster = web
</pre>

Now it's time to configure OCFS2. Run `service o2cb configure` and follow the prompts. Use the defaults for all of the responses except for two questions:

  * Answer &#8220;y&#8221; to &#8220;Load O2CB driver on boot&#8221;
  * Answer &#8220;web&#8221; to &#8220;Cluster to start on boot&#8221;

Start OCFS2 and enable it at boot up:

<pre lang="html">chkconfig o2cb on && chkconfig ocfs2 on
/etc/init.d/o2cb start && /etc/init.d/ocfs2 start
</pre>

Create an OCFS2 partition **on the primary node only**:

<pre lang="html">mkfs.ocfs2 -L "web" /dev/drbd0</pre>

Mount the volumes and configure them to automatically mount at boot time. You might be wondering why I do the mounting within `/etc/rc.local`. I chose to go that route since mounting via fstab was often unreliable for me due to the incorrect ordering of events at boot time. Using rc.local allows the mounts to work properly upon every reboot.

<pre lang="html">mkdir /mnt/storage
echo "/dev/drbd0  /mnt/storage  ocfs2  noauto,noatime  0 0" >> /etc/fstab
mount /dev/drbd0
echo "mount /dev/drbd0" >> /etc/rc.local
</pre>

At this point, you should be all done. If you want to test OCFS2, copy a file into your /mnt/storage mount on one node and check that it appears on the other node. If you remove it, it should be gone instantly on both nodes. This is a great opportunity to test reboots of both machines to ensure that everything comes up properly at boot time.

 [1]: /2010/12/02/keep-web-servers-in-sync-with-drbd-and-ocfs2/
 [2]: http://rpmfusion.org/
 [3]: http://fedoraproject.org/wiki/EPEL
 [4]: http://rackspacecloud.com/
 [5]: /wp-content/uploads/2011/02/loop-for-drbd.txt
 [6]: http://www.drbd.org/users-guide/s-configure-split-brain-behavior.html
