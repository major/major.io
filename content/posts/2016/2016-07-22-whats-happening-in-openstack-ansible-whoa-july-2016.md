---
title: What’s Happening in OpenStack-Ansible (WHOA) – July 2016
author: Major Hayden
date: 2016-07-22T15:48:18+00:00
url: /2016/07/22/whats-happening-in-openstack-ansible-whoa-july-2016/
dsq_thread_id:
  - 5006104821
tags:
  - ansible
  - containers
  - kvm
  - networking
  - open source
  - openstack
  - whoa

---
[<img src="/wp-content/uploads/2011/11/openstack-justheo.png" alt="OpenStack" width="232" height="214" class="alignright size-full wp-image-2592" />][1]This post is the second installment in the series of [What's Happening in OpenStack-Ansible (WHOA)][2] posts that I'm assembling each month. My goal is to inform more people about what we're doing in the OpenStack-Ansible community and bring on more contributors to the project.

July brought lots of changes for the OpenStack-Ansible project and the remaining work for the [Newton release][3] is coming together well. Many of the changes made in the Newton branch have made deployments faster, more reliable and more repeatable.

Let's get to the report!

## New releases

You can always find out about the newest releases for most OpenStack projects on the OpenStack Development mailing list, but I'll give you the shortest summary possible here.

### Kilo

The final Kilo release, [11.2.17][4], is in the books! If you're on Kilo, it's definitely time to move forward.

### Liberty

The latest Liberty release is now [12.1.0][5]. For more information on what's included, review the [release notes][6] or view a [detailed changelog][7].

### Mitaka

Mitaka is the latest stable branch and it's currently at version [13.2.0][8]. It contains lots of bug fixes and a few small backported features. The latest details are always in the [release notes][9] and the [detailed changelog][10].

## Notable discussions

The OpenStack-Ansible mid-cycle is quickly approaching! It runs from August 10th through the 12th at Rackspace's headquarters in San Antonio, Texas. All of the signup information is on the [etherpad][11] along with the proposed agenda. If you're interested in OpenStack deployment automation with Ansible, please feel free to join us!

Support for Open vSwitch is now in OpenStack-Ansible, along with Distributed Virtual Routing (DVR). Travis Truman wrote a [blog post][12] about using the new Open vSwitch support. The support for DVR [was added][13] very recently.

We had a good discussion around standardizing how OpenStack's python services are deployed. Some projects are now recommending the use of uwsgi with their API services. During this week's IRC meeting, we agreed as a group that the best option would be to standardize on uwsgi if possible during the Newton release. If that's not possible, it should be done early in the Ocata release.

Jean-Philippe Evrard [was nominated to be a core developer][14] on OpenStack-Ansible and the thread received many positive comments over the week. Congratulations, JP!

## Notable developments

Lots of work is underway in the Newton release to add support for new features, squash bugs, and reduce the time it takes to deploy a cloud.

### Documentation

Documentation seems to go one of two ways with most projects:

  * Sufficient documentation that is organized poorly (OpenStack-Ansible's current state)
  * Insufficient documentation that is organized well

One of the complaints I heard at the summit was **_"What the heck are we thinking with chapter four?"_**

To be fair, [that chapter][15] is gigantic. While it contains a myriad of useful information, advice, and configuration options, it's overwhelming for beginners and even seasoned deployers.

Work is underway to overhaul the installation guide and provide a simple, easy-to-follow, opinionated method for deploying an OpenStack cloud. This would allow beginners to start on solid ground and have a straightforward deployment guide. The additional information and configuration options would still be available in the documentation, but the documentation will provide strong recommendations for the best possible options.

### Gnocchi deployments

OpenStack-Ansible can now deploy Gnocchi. Gnocchi provides a time series database as a service and it's handy for use with ceilometer, which stores a lot of time-based information.

### Multiple RabbitMQ clusters

Some OpenStack services communicate very frequently with RabbitMQ and that can cause issues for some other services. OpenStack-Ansible now supports independent RabbitMQ clusters for certain services. This allows a deployer to use a different RabbitMQ cluster for handling telemetry traffic than they use for handling nova's messages.

### PowerVM support

Lots of changes were added to allow for multiple architecture support, which is required for full PowerVM support. Some additional fixes for higher I/O performance and OVS on Power support arrived as well.

### Repo server improvements

Building the repo server takes quite a bit of time as repositories are cloned, wheels are built, and virtual environments are assembled. A series of patches merged into the project that aim to reduce the time to build a repo server.

Previously, the repo server built every possible virtual environment that could be needed for an OpenStack-Ansible deployment. Today, the repo server only builds virtual environments for those services that will be deployed. This saves time during the build process and a fair amount of disk space as well.

Source code is also kept on the repo server so that it won't need to be downloaded again for multiple architecture builds.

Additional changes are on the way to only clone the necessary git repositories to the repo server.

### Ubuntu 16.04 (Xenial) support

Almost all of the OpenStack-Ansible roles in Newton have Ubuntu 16.04 support and the integrated gate job is turning green a lot more often this week. We still need some testers who can do some real world multi-server deployments and shake out any bugs that don't appear in an all-in-one (AIO) build.

## Feedback?

The goal of this newsletter is three fold:

  * Keep OpenStack-Ansible developers updated with new changes
  * Inform operators about new features, fixes, and long-term goals
  * Bring more people into the OpenStack-Ansible community to share their use

    cases, bugs, and code

Please let me know if you spot any errors, areas for improvement, or items that I missed altogether. I'm `mhayden` on Freenode IRC and you can find me on [Twitter][17] anytime.

 [1]: /wp-content/uploads/2011/11/openstack-justheo.png
 [2]: /tags/whoa/
 [3]: http://releases.openstack.org/newton/schedule.html
 [4]: https://review.openstack.org/#/c/336505/
 [5]: https://review.openstack.org/#/c/342310/
 [6]: http://docs.openstack.org/releasenotes/openstack-ansible/liberty.html
 [7]: https://gist.github.com/major/c965c67ae56d3a34a30b32d8212c258f
 [8]: https://review.openstack.org/#/c/342307/
 [9]: http://docs.openstack.org/releasenotes/openstack-ansible/mitaka.html
 [10]: https://gist.github.com/major/def75c576cd22c09b5e62fcc2d138202
 [11]: https://etherpad.openstack.org/p/osa-midcycle-newton
 [12]: http://lists.openstack.org/pipermail/openstack-dev/2016-July/098858.html
 [13]: https://review.openstack.org/#/c/338546/
 [14]: https://openstack.nimeyo.com/90118/openstack-openstack-nominating-philippe-openstack-openstack
 [15]: http://docs.openstack.org/developer/openstack-ansible/mitaka/install-guide/configure.html
 [17]: https://twitter.com/majorhayden
