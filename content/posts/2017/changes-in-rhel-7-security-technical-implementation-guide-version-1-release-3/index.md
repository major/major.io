---
aliases:
- /2017/11/02/changes-in-rhel-7-security-technical-implementation-guide-version-1-release-3/
author: Major Hayden
date: 2017-11-02 15:00:25
featured_image: /wp-content/uploads/2017/06/2.jpg
tags:
- ansible
- centos
- debian
- fedora
- information security
- openstack
- opensuse
- python
- red hat
- security
- suse
- ubuntu
title: Changes in RHEL 7 Security Technical Implementation Guide Version 1, Release
  3
---

[<img src="/wp-content/uploads/2017/06/2-300x91.jpg" alt="ansible-hardening logo" width="300" height="91" class="alignright size-medium wp-image-6744" srcset="/wp-content/uploads/2017/06/2-300x91.jpg 300w, /wp-content/uploads/2017/06/2-768x233.jpg 768w, /wp-content/uploads/2017/06/2-1024x311.jpg 1024w" sizes="(max-width: 300px) 100vw, 300px" />][1]The latest release of the Red Hat Enterprise Linux Security Technical Implementation Guide (STIG) [was published last week][2]. This release is Version 1, Release 3, and it contains four main changes:

  * V-77819 - Multifactor authentication is required for graphical logins
  * V-77821 - Datagram Congestion Control Protocol (DCCP) kernel module must be disabled
  * V-77823 - Single user mode must require user authentication
  * V-77825 - Address space layout randomization (ASLR) must be enabled

## Deep dive

Let's break down this list to understand what each one means.

### V-77819 - Multifactor authentication is required for graphical logins

This requirement improves security for graphical logins and extends the existing requirements for multifactor authentication for logins (see V-71965, V-72417, and V-72427). The STIG recommends smartcards (since the US Government often uses [CAC cards][3] for multifactor authentication), and this is a good idea for high security systems.

I use [Yubikey 4's][4] as smartcards in most situations and they work anywhere you have available USB slots.

### V-77821 - Datagram Congestion Control Protocol (DCCP) kernel module must be disabled

[DCCP][5] is often used as a congestion control mechanism for UDP traffic, but it isn't used that often in modern networks. There have been [vulnerabilities][6] in the past that are mitigated by disabling DCCP, so it's a good idea to disable it unless you have a strong reason for keeping it enabled.

The ansible-hardening role has been updated to [disable the DCCP kernel module by default][7].

### V-77823 - Single user mode must require user authentication

Single user mode is often used in emergency situations where the server cannot boot properly or an issue must be repaired without a fully booted server. This mode can only be used at the server's physical console, serial port, or via out-of-band management (DRAC, iLO, and IPMI). Allowing single-user mode access without authentication is a serious security risk.

Fortunately, every distribution supported by the ansible-hardening role already has authentication requirements for single user mode in place. The ansible-hardening role does not make any adjustments to the single user mode unit file since any untested adjustment could cause a system to have problems booting.

### V-77825 - Address space layout randomization (ASLR) must be enabled

[ASLR][8] is a handy technology that makes it more difficult for attackers to guess where a particular program is storing data in memory. It's not perfect, but it certainly raises the difficulty for an attacker. There are multiple settings for this variable and the [kernel documentation for sysctl][9] has some brief explanations for each setting (search for `randomize_va_space` on the page).

Every distribution supported by the ansible-hardening role is already setting `kernel.randomize_va_space=2` by default, which applies randomization for the basic parts of process memory (such as shared libraries and the stack) as well as the heap. The ansible-hardening role will ensure that the default setting is maintained.

## ansible-hardening is already up to date

If you're already using the ansible-hardening role's master branch, these changes are [already in place][10]! Try out the new updates and [open a bug report][11] if you find any problems.

 [1]: /wp-content/uploads/2017/06/2.jpg
 [2]: https://public.cyber.mil/stigs/
 [3]: https://en.wikipedia.org/wiki/Common_Access_Card
 [4]: https://www.yubico.com/products/yubikey-hardware/yubikey4/
 [5]: https://en.wikipedia.org/wiki/Datagram_Congestion_Control_Protocol
 [6]: https://threatpost.com/impact-of-new-linux-kernel-dccp-vulnerability-limited/123863/
 [7]: https://docs.openstack.org/ansible-hardening/latest/rhel7/domains/kernel.html#v-77821
 [8]: https://en.wikipedia.org/wiki/Address_space_layout_randomization
 [9]: https://www.kernel.org/doc/Documentation/sysctl/kernel.txt
 [10]: https://github.com/openstack/ansible-hardening/commit/782bb48c14c03aedaefcaf421fd5935ef5f561b8
 [11]: https://bugs.launchpad.net/openstack-ansible/+filebug