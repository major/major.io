---
aliases:
- /2017/06/27/old-role-new-name-ansible-hardening/
author: Major Hayden
date: 2017-06-27 20:49:44
tags:
- ansible
- information security
- python
- security
title: 'Old role, new name: ansible-hardening'
---

The interest in the [openstack-ansible-security][1] role has taken off faster than I expected, and one piece of constant feedback I received was around the name of the role. Some users were unsure if they needed to use the role in an OpenStack cloud or if the OpenStack-Ansible project was required.

The role works everywhere - OpenStack cloud or not. I started a [mailing list thread][3] on the topic and we eventually settled on a new name: [ansible-hardening][4]! The updated documentation is [already available][5].

The old openstack-ansible-security role is being retired and it will not receive any additional updates. Moving to the new role is easy:

  1. Install _ansible-hardening_ with `ansible-galaxy` (or `git clone`)
  2. Change your playbooks to use the ansible-hardening role

There's no need to change any variable names or tags - they are all kept the same in the new role.

As always, if you have questions or comments about the role, drop by `#openstack-ansible` on Freenode IRC or [open a bug in Launchpad][6].

 [1]: https://github.com/openstack/openstack-ansible-security
 [3]: http://lists.openstack.org/pipermail/openstack-dev/2017-May/116922.html
 [4]: https://github.com/openstack/ansible-hardening
 [5]: https://docs.openstack.org/developer/ansible-hardening/
 [6]: https://bugs.launchpad.net/openstack-ansible/+filebug
