---
aliases:
- /2011/11/07/tracing-a-build-through-openstack-compute-nova/
author: Major Hayden
date: 2011-11-07 15:05:42
tags:
- cloud
- nova
- openstack
- python
title: Tracing a build through OpenStack Compute (Nova)
---

![1]

My work at Rackspace has changed a bit in the last few weeks and I've shifted from managing a team of engineers to a full technical focus on [OpenStack Nova][2]. Although it was difficult to leave my management position, I'm happy to get back to my roots and dig into the technical stuff again.

One of the first things I wanted to tackle was understanding how a build request flows through Nova to a XenServer hypervisor. Following this process through the code is a bit tricky (I'm still learning python, so that could explain it). Here are the basic steps:

* Client requests a build via the API.
* The API runs some checks (quotas, auth, etc) and hands the build off to the scheduler.
* The scheduler figures out where the instance should go.
* The scheduler drops a message in queue specific to one compute node (where the instance will be built).
* The API responds to the client and the client is now unblocked and free to do other things.
* The compute node updates the database with the instance details and calls to the hypervisor to assemble block devices for the instance.
* A message is dropped into the network node's queue (from the compute node) to begin assembling networks for the instance. The compute node blocks and waits while this step completes.
* Once the networking details come back (via the queue), the compute node does the remaining adjustments on the hypervisor and starts up the actual instance.
* When the instance starts successfully (or fails to do so), the database is updated and a message is dropped onto another message queue as a notification that the build is complete.

![3]

Click on the thumbnail on the right to see the flow chart I created to explain this process.

**Please note:** This information should be accurate to the Nova code as of November 1, 2011. There could be some refactoring of these build processes before [Essex][4] is released.

<br style="clear: both;" />

 [1]: /wp-content/uploads/2011/11/openstack-justheo.png
 [2]: http://openstack.org/projects/compute/
 [3]: /wp-content/uploads/2011/11/Tracing-an-Instance-Build-Through-Nova.png
 [4]: https://launchpad.net/nova/essex