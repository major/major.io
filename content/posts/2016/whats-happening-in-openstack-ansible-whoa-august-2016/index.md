---
aliases:
- /2016/08/23/whats-happening-in-openstack-ansible-whoa-august-2016/
author: Major Hayden
date: 2016-08-23 20:35:19
tags:
- ansible
- development
- openstack
- power
- python
- whoa
title: What’s Happening in OpenStack-Ansible (WHOA) – August 2016
---

[<img src="/wp-content/uploads/2011/11/openstack-justheo.png" alt="OpenStack" width="232" height="214" class="alignright size-full wp-image-2592" />][1]Welcome to the third post in the series of [What's Happening in OpenStack-Ansible (WHOA)][2] posts that I'm assembling each month. [OpenStack-Ansible][3] is a flexible framework for deploying enterprise-grade [OpenStack][4] clouds. In fact, I use OpenStack-Ansible to deploy the OpenStack cloud underneath the virtual machine that runs this blog!

My goal with these posts is to inform more people about what we're doing in the OpenStack-Ansible community and bring on more contributors to the project.

There are plenty of updates since the [last post from mid-July][5]. We've had our Mid-cycle meeting and there are plenty of new improvements in flight.

## New releases

The OpenStack-Ansible releases are announced on the OpenStack development mailing list. Here are the things you need to know:

### Liberty

The latest Liberty release, 12.2.1, contains lots of updates and fixes. There are plenty of [neutron bug fixes][6] included in the release along with [upgrade improvements][7]. Deployers also have the option to [block all container restarts][8] until they are ready to reboot containers during a maintenance window.

  * [Version 12.2.1][9]
  * [Release notes][10]
  * [Detailed changelog][11]

### Mitaka

Mitaka is the latest stable release available and the latest version is 13.3.1. This release also [brings in a bunch of neutron fixes][12] and several ["behind the scenes"][13] fixes for OpenStack-Ansible.

  * [Version 13.3.1][14]
  * [Release notes][15]
  * [Detailed changelog][16]

## Notable discussions

This section covers discussions from the OpenStack-Ansible weekly meetings, IRC channels, mailing lists, or in-person events.

### Mid-cycle meeting

We had a great mid-cycle meeting at the Rackspace headquarters in San Antonio, Texas:

<blockquote class="twitter-tweet tw-align-center" data-width="500">
  <p lang="en" dir="ltr">
    The <a href="https://twitter.com/OpenStack">@OpenStack</a>-Ansible mid-cycle meeting is about to start! <a href="https://t.co/DSYKJF5wou">pic.twitter.com/DSYKJF5wou</a>
  </p>

  <p>
    &mdash; Major Hayden (@majorhayden) <a href="https://twitter.com/majorhayden/status/763377905615249408">August 10, 2016</a>
  </p>
</blockquote>



The meeting drew community members from various companies from all over the United States and the United Kingdom. We talked about the improvements we need to make in the remainder of the Newton cycle, including upgrades, documentation improvements, and new roles.

Here is a run-down of the biggest topics:

#### Install guide overhaul

The new install guide is quickly coming together and it's much easier to follow for newcomers. There is a big need now for detailed technical reviews to ensure that the new content is clear and accurate!

#### Ansible 2.1

The decision was made to bump each of the role repositories to Ansible 2.1 to match the integrated repository. It was noted that Ansible 2.2 will bring some performance improvements once it is released.

#### Ubuntu 16.04 Xenial Support

This is a high priority for the remainder of the Newton cycle. The Xenial gate jobs will be switched to voting and Xenial failures will need to be dealt with before any additional patches will be merged.

#### Ubuntu 14.04 Trusty Support

Many of the upstream OpenStack projects are removing 14.04 support soon and OpenStack-Ansible will drop 14.04 support in the Ocata release.

#### Power CPU support

There's already support for Power systems as hypervisors within OpenStack-Ansible now and IBM is testing mixed x86 and PPC environments now. However, we still need some way to test these mixed environments in the OpenStack gate tests. Two IBMers from the OpenStack-Ansible community are working with the infra team to find out how this can be

done.

#### Inventory improvements

The inventory generation process for OpenStack-Ansible is getting more tests and better documentation. Generating inventory is a difficult process to understand, but it is critical for the project's success.

#### Gnocchi / Telemetry improvements

We got an update on gnocchi/ceilometer and set some plans on how to go forward with the OpenStack services and the data storage challenges that go along with each.

### Mailing list

The OpenStack-Ansible tag was fairly quiet on the OpenStack Development mailing list during the time frame of this report, but there were a few threads:

  * [Adding RHEL 7 STIG to openstack-ansible-security][17]
  * [git repo in infra_repo container not working][18]

### Blogs

Michael Gugino wrote about [deploying nova-lxd with OpenStack-Ansible][19]. This is one of the newest features in OpenStack-Ansible.

I [wrote one about an issue][20] that was really difficult to track down. I had instances coming online with multiple network ports attached when I only asked for one port. It turned out to be a glance issue that caused a problem in nova.

## Notable developments

This section covers some of the improvements coming to Newton, the upcoming OpenStack release.

### Bug fixes

Services were logging to stderr and this caused some log messages to be logged multiple times on the same host. This ate up additional disk space and disk I/O performance. [Topic][21]

The xtrabackup utility causes crashes during certain situations when the `compact` option is used. [Reviews][22]

### Dashboard

LBaaS v2 panels were added to Newton and Mitaka. Ironic and Magnum panels were added to Newton.

### Documentation

Plenty of work was merged towards improving the installation guide to make it more concise and easy to follow. [Topic][23]

### Multi-Architecture support

Repo servers can now build Python wheels for multiple architectures. This allows for mixed control/data plane environments, such as x86 (Intel) control planes with PPC (Power8) hypervisors running PowerKVM or PowerVM. [Review][24]

### Performance improvements

The repo servers now act as an apt repository cache, which helps improve the speed of deployments. This also helps with deployers who don't have an active internet connection in their cloud.

The repo servers now only build the wheels and virtual environments necessary for the services which are actually being deployed. This reduces the wait required while the wheels and virtual environments are built, but it also has an added benefit of reducing the disk space consumed. [Topic][25]

### Upgrades

The MariaDB restarts during upgrades are now handled more carefully to avoid disruptions from container restarts. [Review][26]

Deployers now have the option to choose if they want packages updated during a deployment or during an upgrade. There are per-role switches as well as a global switch that can be toggled. [Topic][27]

## Feedback?

The goal of this newsletter is three fold:

  * Keep OpenStack-Ansible developers updated with new changes
  * Inform operators about new features, fixes, and long-term goals
  * Bring more people into the OpenStack-Ansible community to share their use

    cases, bugs, and code

Please let me know if you spot any errors, areas for improvement, or items that I missed altogether. I'm `mhayden` on Freenode IRC and you can find me on [Twitter][28] anytime.

 [1]: /wp-content/uploads/2011/11/openstack-justheo.png
 [2]: /tags/whoa/
 [3]: https://wiki.openstack.org/wiki/OpenStackAnsible
 [4]: http://openstack.org
 [5]: https://major.io/2016/07/22/whats-happening-in-openstack-ansible-whoa-july-2016/
 [6]: https://gist.github.com/anonymous/6fafe3a92ba4f8d20b17d1688de29c03#neutron
 [7]: https://github.com/openstack/openstack-ansible/commit/5cb4b90b5c00f3c6db06249aea7db1d259723022
 [8]: https://github.com/openstack/openstack-ansible/commit/bc0046b751a0c554903263ad6781485013c2b51d
 [9]: https://review.openstack.org/#/c/355513/
 [10]: http://docs.openstack.org/releasenotes/openstack-ansible/liberty.html
 [11]: https://gist.github.com/anonymous/6fafe3a92ba4f8d20b17d1688de29c03
 [12]: https://gist.github.com/anonymous/02e9e4ce95cb54e903876d6ddf13c1ad#neutron
 [13]: https://gist.github.com/anonymous/02e9e4ce95cb54e903876d6ddf13c1ad#openstack-ansible
 [14]: https://review.openstack.org/355509
 [15]: http://docs.openstack.org/releasenotes/openstack-ansible/mitaka.html
 [16]: https://gist.github.com/anonymous/02e9e4ce95cb54e903876d6ddf13c1ad
 [17]: http://lists.openstack.org/pipermail/openstack-dev/2016-August/100883.html
 [18]: http://lists.openstack.org/pipermail/openstack-dev/2016-August/101400.html
 [19]: https://medium.com/@michaelgugino/deploying-nova-lxd-hypervisors-with-openstack-ansible-39525157879d#.ot5yb7rwt
 [20]: https://major.io/2016/08/03/openstack-instances-come-online-with-multiple-network-ports-attached/
 [21]: https://review.openstack.org/#/q/topic:bug/1588051
 [22]: https://review.openstack.org/#/q/topic:bug/1590166
 [23]: https://review.openstack.org/#/q/project:%255Eopenstack/openstack-ansible-.*+branch:master+topic:bp/osa-install-guide-overhaul
 [24]: https://review.openstack.org/#/c/346863/
 [25]: https://review.openstack.org/#/q/topic:repo-build-optimise
 [26]: https://review.openstack.org/#/c/354642/
 [27]: https://review.openstack.org/#/q/topic:package-install-state-option
 [28]: https://twitter.com/majorhayden