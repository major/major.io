---
title: What’s Happening in OpenStack-Ansible (WHOA) – September 2016
author: Major Hayden
date: 2016-09-30T14:33:33+00:00
url: /2016/09/30/whats-happening-in-openstack-ansible-whoa-september-2016/
featured_image: /wp-content/uploads/2016/09/1024px-Arc_de_Triomf_Barcelona.jpg
dsq_thread_id:
  - 5185817584
tags:
  - ansible
  - development
  - openstack
  - python
  - whoa

---
![1]

Welcome to the fourth post in the series of [What's Happening in OpenStack-Ansible (WHOA)][2] posts that I'm assembling each month. [OpenStack-Ansible][3] is a flexible framework for deploying enterprise-grade [OpenStack][4] clouds. In fact, I use OpenStack-Ansible to deploy the OpenStack cloud underneath the virtual machine that runs this blog!

My goal with these posts is to inform more people about what we're doing in the OpenStack-Ansible community and bring on more contributors to the project.

There are plenty of updates since the [last post from August][5]. The race is on to finish up the Newton release and start new developments for the Ocata release! We hope to see lots of contributors in Barcelona!

![6]

## New releases

The OpenStack-Ansible releases are announced on the OpenStack development mailing list. Here are the things you need to know:

### Newton

The OpenStack-Ansible Newton release is still being finalized this week. The `stable/newton` branches were [created yesterday][7] and stabilization work is ongoing.

### Mitaka

Mitaka is the latest stable release available and the latest version is 13.3.4. This release includes some upgrade improvements for [ml2 ports][8] and [container hostname adjustments][9].

  * [Version 13.3.4][10]
  * [Release notes][11]
  * [Detailed changelog][12] _(from 13.3.1 to 13.3.4)_

### Liberty

The latest Liberty release, 12.2.4, contains lots of updates and fixes. The updates include a [fix for picking up where you left off on a failed upgrade][13] and a [fix for duplicated log lines][14]. The security role received [some updates][15] to improve performance and reduce unnecessary logging.

  * [Version 12.2.4][16]
  * [Release notes][17]
  * [Detailed changelog][18] _(from 12.2.1 to 12.2.4)_

## Notable discussions

This section covers discussions from the OpenStack-Ansible weekly meetings, IRC channels, mailing lists, or in-person events.

### Newton branch

As mentioned earlier, the `stable/newton` branches have arrived for OpenStack-Ansible! This will allow us to finish stabilizing the Newton release and look ahead to Ocata.

### Octavia

Michael Johnson and Jorge Miramontes stopped by our weekly meeting to talk about how Octavia could be implemented in OpenStack-Ansible. Recent Octavia releases have some new features that should be valuable to OpenStack-Ansible deployers.

There is a [spec from the Liberty release][19] for deploying Octavia, but we were only able to get LBaaSv2 with the agent deployed. Jorge and Michael are working on a new spec to get Octavia deployed with OpenStack-Ansible.

### Testing repo

There's now a [centralized testing repository][20] for all OpenStack-Ansible roles. This allows the developers to share variables, scripts, and test cases between multiple roles. Developers can begin testing new roles with much less effort since the scaffolding for a basic test environment is available in the repository.

You can follow along with the development by watching the [central-test-config][21] topic in Gerrit.

### Mailing list

The OpenStack-Ansible tag was fairly quiet on the OpenStack Development mailing list during the time frame of this report, but there were a few threads:

  * [cinder volume lxc and iscsi][22]
  * [Blueprint discussion][23] _(for the Ocata OpenStack Summit)_
  * [Newton RC2 available][24]

## Notable developments

This section covers some of the improvements coming to Newton, the upcoming OpenStack release.

### OpenStack-Ansible Training

[<img src="/wp-content/uploads/2016/09/hastexo-logo-e1475245310720.png" alt="Hastexo logo" width="149" height="110" class="alignright size-full wp-image-6482" />][25][Hastexo][26] is now offering a [self-paced course][27] for learning OpenStack-Ansible! It's called HX201 Cloud Fundamentals for OpenStack-Ansible and it is available now.

Thanks to Florian Haas and Adolfo Brandes for assembling this course!

### OpenStack-Ansible powers the OSIC cloud

[<img src="/wp-content/uploads/2016/09/OSIC-Logo.png" alt="OpenStack Innovation Center" width="260" height="107" class="alignright size-full wp-image-6487" />][29]One of the clouds operated by the [OpenStack Innovation Center (OSIC)][30] is powered by OpenStack-Ansible. It's a dual-stack (IPv4 and IPv6) environment and it provides the most nodes for the OpenStack CI service! If you need to test an application on a large OpenStack cloud, [apply for access][31] to the OSIC cluster.

### Inventory improvements

The backbone of OpenStack-Ansible is its inventory. The dynamic inventory defines where each service should be deployed, configured and managed. Some recent improvements include [exporting inventory][32] for use by other scripts or applications. Ocata should bring even more improvements to the dynamic inventory.

Thanks to Nolan Brubaker for leading this effort!

### Install guide

The installation guide has been completely overhauled! It has a more concise, opinionated approach to deployments and this should make the first deployment a little easier for newcomers. OpenStack can be a complex system to deploy and our goal is to provide the cleanest path to a successful deployment.

Thanks to Alex Settle for leading this effort!

## Feedback?

The goal of this newsletter is three fold:

  * Keep OpenStack-Ansible developers updated with new changes
  * Inform operators about new features, fixes, and long-term goals
  * Bring more people into the OpenStack-Ansible community to share their use

    cases, bugs, and code

Please let me know if you spot any errors, areas for improvement, or items that I missed altogether. I'm `mhayden` on Freenode IRC and you can find me on [Twitter][33] anytime.

_Photo credit: Mattia Felice Palermo (Own work) [CC BY-SA 3.0 es][34], via Wikimedia Commons_

 [1]: /wp-content/uploads/2011/11/openstack-justheo.png
 [2]: /tags/whoa/
 [3]: https://wiki.openstack.org/wiki/OpenStackAnsible
 [4]: http://openstack.org
 [5]: /2016/08/23/whats-happening-in-openstack-ansible-whoa-august-2016/
 [6]: /wp-content/uploads/2016/09/1024px-Arc_de_Triomf_Barcelona.jpg
 [7]: https://review.openstack.org/#/c/379590/
 [8]: https://review.openstack.org/#/c/366169/
 [9]: https://review.openstack.org/#/c/360539/
 [10]: https://review.openstack.org/379499
 [11]: http://docs.openstack.org/releasenotes/openstack-ansible/mitaka.html
 [12]: https://gist.github.com/anonymous/3880b24f381d7d4d31be036ef820c21e
 [13]: https://review.openstack.org/#/c/360385/
 [14]: https://review.openstack.org/#/c/368066/
 [15]: https://gist.github.com/anonymous/9fe1f5110e2d8f7c1d148d4b6968b5a9#openstack-ansible-security
 [16]: https://review.openstack.org/379505/
 [17]: http://docs.openstack.org/releasenotes/openstack-ansible/liberty.html
 [18]: https://gist.github.com/anonymous/9fe1f5110e2d8f7c1d148d4b6968b5a9
 [19]: http://specs.openstack.org/openstack/openstack-ansible-specs/specs/mitaka/lbaasv2.html
 [20]: https://github.com/openstack/openstack-ansible-tests
 [21]: https://review.openstack.org/#/q/topic:central-test-config
 [22]: http://lists.openstack.org/pipermail/openstack-dev/2016-September/103671.html
 [23]: http://lists.openstack.org/pipermail/openstack-dev/2016-September/104813.html
 [24]: http://lists.openstack.org/pipermail/openstack-dev/2016-September/104807.html
 [25]: /wp-content/uploads/2016/09/hastexo-logo-e1475245310720.png
 [26]: https://www.hastexo.com/
 [27]: https://www.hastexo.com/resources/news-releases/hx201-ansible
 [29]: /wp-content/uploads/2016/09/OSIC-Logo.png
 [30]: https://osic.org/
 [31]: https://osic.org/clusters
 [32]: https://review.openstack.org/#/c/371798/
 [33]: https://twitter.com/majorhayden
 [34]: http://creativecommons.org/licenses/by-sa/3.0/es/deed.en
