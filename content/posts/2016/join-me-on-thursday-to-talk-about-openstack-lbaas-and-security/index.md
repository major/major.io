---
aliases:
- /2016/07/19/join-me-on-thursday-to-talk-about-openstack-lbaas-and-security/
author: Major Hayden
date: 2016-07-19 14:09:40
dsq_thread_id:
- 4997538148
tags:
- load balancing
- networking
- openstack
- rackspace
- security
title: Join me on Thursday to talk about OpenStack LBaaS and security hardening
---

![1]

If you want to learn more about load balancers and security hardening in [OpenStack][2] clouds, join me on Thursday for the Rackspace Office Hours podcast[^3]! [Walter Bentley][4], [Kenneth Hui][5] and I will be talking about some of the new features available in the [12.2 release][6] of [Rackspace Private Cloud powered by OpenStack][7].

The release has a tech preview of OpenStack's [Load Balancer as a Service project][8]. The new LBaaSv2 API is stable and makes it easy to create load balancers, add pools, and add members. Health monitors can watch over servers and remove those servers from the load balancers if they don't respond properly.

![9]

I [talked about the security hardening feature][10] extensively at this year's OpenStack Summit in Austin and it is now available in the 12.2 release of RPC.

The new Ansible role and its tasks apply over 200 security hardening configurations to OpenStack hosts (control plane and hypervisors) and it comes with extensive auditor-friendly documentation. The documentation also allows deployers to fine-tune many of the configurations and disable the ones they don't want. Deployers also have the option to tighten some configurations depending on their industry requirements.

Join us this Thursday, July 21st, at 1:00 PM CDT ([check your time zone][11]) to talk more about these new features and OpenStack in general.

[1]: /wp-content/uploads/2016/07/podcast-header-openstack.png
[2]: http://openstack.org/
[4]: https://twitter.com/djstayflypro
[5]: https://twitter.com/kenhuiny
[6]: http://blog.rackspace.com/rackspace-private-cloud-v12-2-hardening-openstack/
[7]: https://www.rackspace.com/cloud/private/openstacksolutions/openstack
[8]: https://wiki.openstack.org/wiki/Neutron/LBaaS
[9]: /wp-content/uploads/2016/04/OpenStack-Summit-Austin-2016-Automated-Security-Hardening-with-OpenStack-Ansible-Major-Hayden-1.png
[10]: /2016/04/26/talk-recap-automated-security-hardening-openstack-ansible/
[11]: http://everytimezone.com/#2016-7-21,360,cn3

[^3]: The podcast link was removed after the post was written.