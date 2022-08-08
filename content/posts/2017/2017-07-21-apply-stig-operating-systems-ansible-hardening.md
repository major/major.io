---
title: Apply the STIG to even more operating systems with ansible-hardening
author: Major Hayden
date: 2017-07-21T17:38:46+00:00
url: /2017/07/21/apply-stig-operating-systems-ansible-hardening/
featured_image: /wp-content/uploads/2017/07/1024px-Samuils_Fortress_and_Ohrid_Lake.jpg
tags:
  - ansible
  - debian
  - fedora
  - linux
  - opensuse
  - security
  - suse

---
![1]

Tons of improvements made their way into the [ansible-hardening][2] role in preparation for the OpenStack Pike release [next month][3]. The role has a [new name][4], new [documentation][5] and extra tests.

The role uses the Security Technical Implementation Guide (STIG) produced by the Defense Information Systems Agency (DISA) and applies the guidelines to Linux hosts using Ansible. Every control is configurable via simple Ansible variables and each control is thoroughly documented.

These controls are now applied to an even wider variety of Linux distributions:

  * CentOS 7
  * Debian 8 Jessie _(new for Pike)_
  * Fedora 25 _(new for Pike)_
  * openSUSE Leap 42.2+ _(new for Pike)_
  * Red Hat Enterprise Linux 7
  * SUSE Linux Enterprise 12 _(new for Pike)_
  * Ubuntu 14.04 Trusty
  * Ubuntu 16.04 Xenial

Any patches to the ansible-hardening role are tested against all of these operating systems (except RHEL 7 and SUSE Linux Enterprise). Support for openSUSE testing [landed this week][6].

**Work is underway to put the finishing touches on the master branch before the Pike release and we need your help!**

If you have any of these operating systems deployed, please test the role on your systems! This is pre-release software, so it's best to apply it only to a new server. Read the ["Getting Started"][7] documentation to get started with `ansible-galaxy` or `git`.

_Photo credit: [Wikipedia][8]_

 [1]: /wp-content/uploads/2017/07/1024px-Samuils_Fortress_and_Ohrid_Lake.jpg
 [2]: https://github.com/openstack/ansible-hardening
 [3]: https://releases.openstack.org/pike/schedule.html
 [4]: /2017/06/27/old-role-new-name-ansible-hardening/
 [5]: https://docs.openstack.org/ansible-hardening/latest/
 [6]: https://github.com/openstack-infra/project-config/commit/0795a7414ca8f06931877919d7ecb0b2d4e5f6e0
 [7]: https://docs.openstack.org/ansible-hardening/latest/getting-started.html
 [8]: https://commons.wikimedia.org/wiki/File%3ASamuil's_Fortress_and_Ohrid_Lake.JPG
