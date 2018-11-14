---
title: 'Automated security hardening with Ansible: May updates'
author: Major Hayden
type: post
date: 2016-05-27T02:40:33+00:00
url: /2016/05/26/automated-security-hardening-with-ansible-may-updates/
dsq_thread_id:
  - 4860980174
categories:
  - Blog Posts
tags:
  - centos
  - openstack
  - security
  - ubuntu

---
![1]

Lots of work has gone into the [openstack-ansible-security][2] Ansible role since I delivered [a talk about it last month][3] at the OpenStack Summit in Austin. Attendees asked for quite a few new features and I've seen quite a few bug reports (and that's a good thing).

Here's a list of the newest additions since the Summit:

## New features

### Ubuntu 16.04 LTS (Xenial) support

The role now works with Ubuntu 16.04 and its newest features, including systemd. You can use the same variables as you used with Ubuntu 14.04 and it should take the same actions. Documentation updates are mostly merged with a few straggling reviews in the queue.

### CentOS 7 support

With all of the work going into the role to support Ubuntu 16.04 and systemd, CentOS 7 wasn't a huge stretch. Many of the package names and file locations were a little different, but those are now moved out into variables files to reduce the repetition of tasks. Some of the Linux Security Module tasks needed adjustments since SELinux is a different beast than AppArmor.

### Following the STIG more closely

One of the common questions I had at the summit was: "Can I use this thing on my non-OpenStack environments?" You definitely can, but many of the configurations were tweaked to avoid causing problems with OpenStack environments. Some users asked if the configurations could be made more generic so that they followed the STIG more closely. This would reduce some compliance headaches and allow more people to use the role.

So far, I've been making some of these adjustments to fix more things rather than simply checking them. That should make it easier to get closer to the STIG's requirements.

Another proposed idea is to create vars files that meet different criteria. For example, one vars file might be the ultra-secure, follow-the-STIG-to-the-letter configuration. This would be good for users that already know they want to apply the STIG's requirements fully. There could be another vars file that would apply most of the STIG's requirements, but it would steer clear of changing anything that could disrupt a production OpenStack environment.

## The future

Here are a subset of the future plans and ideas:

  * Better reporting for users who need to feed data into vulnerability management applications or SIEMs for compliance checks
  * Better testing, possibly with customized OpenSCAP XCCDF files
  * Cross-referenced controls to other hardening guides, such as CIS Benchmarks

If you have any other ideas, feel free to stop by `#openstack-ansible` or `#openstack-security` on Freenode. You can find me there as _mhayden_ and I would really enjoy hearing about your use cases!

_Photo credit: [Mikecogh][4]_

 [1]: /wp-content/uploads/2016/05/15843531002_f92f4e6c50_o-e1464316716989.jpg
 [2]: https://github.com/openstack/openstack-ansible-security
 [3]: /2016/04/26/talk-recap-automated-security-hardening-openstack-ansible/
 [4]: https://www.flickr.com/photos/89165847@N00/15843531002/
