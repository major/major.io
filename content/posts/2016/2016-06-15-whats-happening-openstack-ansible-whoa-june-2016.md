---
title: What’s Happening in OpenStack-Ansible (WHOA) – June 2016
author: Major Hayden
date: 2016-06-15T19:58:52+00:00
url: /2016/06/15/whats-happening-openstack-ansible-whoa-june-2016/
dsq_thread_id:
  - 4913204592
tags:
  - ansible
  - containers
  - kvm
  - networking
  - open source
  - openstack
  - whoa
  - xen

---
[<img src="/wp-content/uploads/2011/11/openstack-justheo.png" alt="OpenStack " width="232" height="214" class="alignright size-full wp-image-2592" />][1]The world of OpenStack moves quickly. Each day brings new features, new bug fixes, and new ways of thinking. The [OpenStack-Ansible community][2] strives to understand these changes and make them easier for operators to implement.

The [OpenStack-Ansible project][3] is a collection of playbooks and roles written by operators for operators. These playbooks make it easier to deploy, maintain, and upgrade an OpenStack cloud.

Keeping up with the changes in the OpenStack-Ansible project is challenging. After reading Hugh Blemings' [Last Week in OpenStack Dev][4] reports, I thought it would be useful to have a more focused newsletter on where OpenStack-Ansible has been

recently and where it will go. My goal is to share this on a monthly cadence, but that may change over time.

Without further ado, here is the inaugural WHOA report for June 2016!

## New releases

The OpenStack-Ansible project has four active branches under various stages of development.

### Newton

The Newton (master) branch is still under heavy development and will be released later in the year along with other OpenStack projects. For more details on the Newton development efforts, take a look at the **_Notable developments_** and **_On the horizon_** sections below.

### Mitaka

The latest release in the Mitaka branch is 13.1.2 and it was [released][5] on June 2nd, 2016.

This release contained several new backported features and fixes, such as:

  * Horizon: LBaaS v2 panels and IPv6 management support can be enabled
  * Swift: better handling for full disks
  * Security: fixes for audit logs filling disks and ssh configurations with `Match` stanzas

More details are available in the full [release notes for 13.1.2][6].

The release also [contains many updates][7] for OpenStack services and related dependencies.

### Liberty

The latest release in the Liberty branch is 12.0.14 and it was [released][8] on June 2nd 2016.

This release contains many of the same fixes that appeared in the Mitaka release (see above).

More details are available in the full [release notes for 12.0.14][9].

The release also [contains many updates][10] for OpenStack services and related dependencies.

### Kilo

Although no releases have appeared in the Kilo branch in the last 30 days, **work is being done for the final kilo release**. This release will be tagged as 11.2.17 and should be available once the upstream OpenStack projects have completed their _kilo-eol_ tags.

There is a [mailing list thread][11] about the _kilo-eol_ Kilo tagging efforts. It has status updates that are specific to each OpenStack project.

## Notable discussions

Want to discuss OpenStack-Ansible with the community? We want to hear from you!

Feel free to join us in `#openstack-ansible` on Freenode or send email to [openstack- dev@lists.openstack.org][12] with `[openstack-ansible]` in the subject line. Our meeting times and logs from previous meetings are in the [OpenStack-Ansible wiki][13].

### Newton mid-cycle

The planning for the Newton mid-cycle is underway. It will be held at Rackspace's headquarters in San Antonio, Texas from August 10th through the 12th. You can find lots of details about the venues and hotel arrangements in the [etherpad][14].

It's possible that remote participation will work in the room, but that isn't guaranteed at this time. Previous attempts at videoconferencing didn't work terribly well, but we will give it our best try!

## Notable developments

Many blueprints are in flight for the Newton release. I will touch on some of the most important and the most impactful ones here.

### Ubuntu 16.04 (Xenial) support

Many of the OpenStack-Ansible roles are compatible with Ubuntu 16.04 or are on the way to becoming compatible. All of the roles have non-voting gate jobs enabled for Ubuntu 16.04 to make it easier to for developers to see how their patches work on multiple versions of Ubuntu.

For the latest updates on which roles are compatible with Ubuntu 16.04, refer to the [etherpad][15]. The blueprint is [on Launchpad][16] and you can follow along with the latest patches by filtering the [bp/support-ubuntu-1604][17] topic in Gerrit.

### Installation documentation overhaul

At the Summit in Austin, many people mentioned that the OpenStack-Ansible installation documentation contains lots of great information, but it is very difficult to navigate. It can become even more challenging for newcomers.

A [new spec][18] lays out the plans for the improvements in the Newton release and work is already underway.

Here are some more helpful links if you want to follow the development or make improvements of your own:

  * [Blueprint][19]
  * [bp/osa-install-guide-overhaul][20] topic in Gerrit
  * [Etherpad with notes from the OpenStack Summit][21]

### Ansible 2.1 support

Ansible 2.1 [is now the default Ansible version][22] used in OpenStack-Ansible for the Newton release. Individual role cleanups to address deprecation warnings and bare variables are [in progress][23].

## On the horizon

The OpenStack-Ansible community is always looking for ways to improve OpenStack-Ansible. Some of these improvements allow the project to do something completely new, such as deploying a new OpenStack service. Others make the project easier to use or reduce the time required for deployment.

The following work items are in various stages of development in the Newton release.

### Astara

Work is underway to deploy Astara with OpenStack-Ansible. Astara provides a new way to handle layer 3 networking services, such as routers, load balancers, and VPN endpoints. Neutron would still handle the layer 2 networking (such as VLAN tagging), but Astara would run layer 3 services within service virtual machines that exist under an admin tenant.

For more details, see the [blueprint][24] or the [etherpad][25]. Phil Hopkins is leading this effort and hopes to have a spec proposed soon.

### Magnum

The [Magnum][26] project allows users to deploy and manage Docker and Kubernetes deployments via calls to the Magnum API.

Many of the OpenStack-Ansible and Magnum developers have [submitted patches][27] to make the [os_magnum role][28] more mature and feature-rich.

### Multiple architectures and PowerVM

We welcomed some new community members from IBM who are working to implement PowerVM support in OpenStack-Ansible. Since most of our use cases were on x86-based systems, this requires some rework in various places within the project. Some of the biggest changes will be made within the repo server since some python modules contain code that must be compiled on the Power architecture.

Adam Reznechek from IBM is [drafting a spec][29] that provides details on the required changes. These changes should allow deployers to mix and match hosts within an OpenStack environment. This could allow for some interesting use cases:

  * Mixed deployments of x86 and Power hypervisors
  * x86 control plane with Power hypervisors
  * Power control plane with x86 hypervisors

This flexible framework could allow for ARM development in later releases.

### Operator scripts

A new repository called [openstack-ansible-ops][30] will contain resources for operators of OpenStack-Ansible clouds.

One of the first proposed scripts is `osa-differ.py`. [This script][31] allows operators to understand the OpenStack changes that exist between two OpenStack-Ansible releases. If you're waiting on a fix for a bug in an OpenStack service, you could use this script to see if the fix made it into a particular version of OpenStack-Ansible.

### Sahara

The [Sahara][32] project provisions services like Hadoop or Spark to process big chunks of data. OpenStack-Ansible can deploy Sahara now with the new [os_sahara role][33].

### Xen

Many large clouds use the Xen hypervisor and Antony Messerli is working to implement Xen hypervisor support with libvirt in OpenStack-Ansible. A [new spec][34] recently merged that explains the benefits behind the work as well as the changes that are required to make it work.

## Feedback?

The goal of this newsletter is three fold:

  * Keep OpenStack-Ansible developers updated with new changes
  * Inform operators about new features, fixes, and long-term goals
  * Bring more people into the OpenStack-Ansible community to share their use

    cases, bugs, and code

Please let me know if you spot any errors, areas for improvement, or items that I missed altogether. I'm `mhayden` on Freenode IRC and you can find me on [Twitter][35] anytime.

 [1]: /wp-content/uploads/2011/11/openstack-justheo.png
 [2]: https://wiki.openstack.org/wiki/OpenStackAnsible
 [3]: http://docs.openstack.org/developer/openstack-ansible/
 [4]: http://hugh.blemings.id.au/openstack/lwood/
 [5]: https://review.openstack.org/#/c/324759/
 [6]: http://docs.openstack.org/releasenotes/openstack-ansible/mitaka.html
 [7]: https://gist.github.com/major/dc2f1f9c99adaa180f69e176fde2fff9
 [8]: https://review.openstack.org/#/c/324760/
 [9]: http://docs.openstack.org/releasenotes/openstack-ansible/liberty.html
 [10]: https://gist.github.com/major/02d4ee0c2dac62ed279d8f052029c100
 [11]: https://openstack.nimeyo.com/86382/openstack-dev-stable-all-tagging-kilo-eol-for-the-world
 [12]: mailto:openstack-dev@lists.openstack.org
 [13]: https://wiki.openstack.org/wiki/Meetings/openstack-ansible
 [14]: https://etherpad.openstack.org/p/osa-midcycle-newton
 [15]: https://etherpad.openstack.org/p/openstack-ansible-newton-ubuntu16-04
 [16]: https://blueprints.launchpad.net/openstack-ansible/+spec/multi-platform-host
 [17]: https://review.openstack.org/#/q/topic:bp/support-ubuntu-1604,n,z
 [18]: http://specs.openstack.org/openstack/openstack-ansible-specs/specs/newton/osa-install-guide-overhaul.html
 [19]: https://blueprints.launchpad.net/openstack-ansible/+spec/osa-install-guide-overhaul
 [20]: https://review.openstack.org/#/q/topic:bp/osa-install-guide-overhaul,n,z
 [21]: https://etherpad.openstack.org/p/openstack-ansible-newton-role-docs
 [22]: https://review.openstack.org/#/c/321042/
 [23]: https://review.openstack.org/#/q/topic:bp/ansible-2-1-support
 [24]: https://blueprints.launchpad.net/openstack-ansible/+spec/add-support-for-astara
 [25]: https://etherpad.openstack.org/p/astara-openstack-ansible
 [26]: https://wiki.openstack.org/wiki/Magnum
 [27]: https://review.openstack.org/#/q/project:openstack/openstack-ansible-os_magnum
 [28]: https://github.com/openstack/openstack-ansible-os_magnum
 [29]: https://review.openstack.org/#/c/329637/
 [30]: https://github.com/openstack/openstack-ansible-ops
 [31]: https://review.openstack.org/#/c/328469/
 [32]: https://wiki.openstack.org/wiki/Sahara
 [33]: https://github.com/openstack/openstack-ansible-os_sahara
 [34]: http://specs.openstack.org/openstack/openstack-ansible-specs/specs/newton/xen-virt-driver.html
 [35]: https://twitter.com/majorhayden
