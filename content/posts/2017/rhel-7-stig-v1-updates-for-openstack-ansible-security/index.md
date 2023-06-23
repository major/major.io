---
aliases:
- /2017/04/05/rhel-7-stig-v1-updates-for-openstack-ansible-security/
author: Major Hayden
date: 2017-04-05 17:46:17
tags:
- ansible
- centos
- linux
- openstack
- python
- red hat
- security
title: RHEL 7 STIG v1 updates for openstack-ansible-security
---

[<img src="/wp-content/uploads/2017/04/OpenStack-Logo-Horizontal-e1491414195297-300x67.png" alt="OpenStack Logo" width="300" height="67" class="alignright size-medium wp-image-6674" srcset="/wp-content/uploads/2017/04/OpenStack-Logo-Horizontal-e1491414195297-300x67.png 300w, /wp-content/uploads/2017/04/OpenStack-Logo-Horizontal-e1491414195297.png 510w" sizes="(max-width: 300px) 100vw, 300px" />][1]DISA's final release of the Red Hat Enterprise Linux (RHEL) 7 Security Technical Implementation Guide (STIG) [came out a few weeks ago][2] and it has plenty of improvements and changes. The openstack-ansible-security role has already been updated with these changes.

Quite a few duplicated STIG controls were removed and a few new ones were added. Some of the controls in the pre-release were difficult to implement, especially those that changed parameters for PKI-based authentication.

The biggest challenge overall was the renumbering. The pre-release STIG used an unusual numbering convention: RHEL-07-123456. The final version used the more standardized "V" numbers, such as V-72225. This change required a [substantial patch][3] to bring the Ansible role inline with the new STIG release.

All of the [role's documentation][4] is now updated to reflect the new numbering scheme and STIG changes. The key thing to remember is that you'll need to use `--skip-tag` with the new STIG numbers if you need to skip certain tasks.

**Note:** These changes won't be backported to the `stable/ocata` branch, so you need to use the `master` branch to get these changes.

Have feedback? Found a bug? Let us know!

  * IRC: `#openstack-ansible` on Freenode IRC
  * Bugs: [LaunchPad][5]
  * E-mail: <openstack-dev@lists.rackspace.com> with the subject line `[openstack-ansible][security]`

 [1]: /wp-content/uploads/2017/04/OpenStack-Logo-Horizontal-e1491414195297.png
 [2]: https://public.cyber.mil/stigs/
 [3]: https://github.com/openstack/openstack-ansible-security/commit/dccce1d5cc06985a58f0ecba4fd0d977388592b2
 [4]: https://docs.openstack.org/developer/openstack-ansible-security/controls-rhel7.html
 [5]: https://bugs.launchpad.net/openstack-ansible