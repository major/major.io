---
title: What I learned while securing Ubuntu
author: Major Hayden
date: 2015-10-14T20:53:12+00:00
url: /2015/10/14/what-i-learned-while-securing-ubuntu/
tags:
  - ansible
  - apparmor
  - debian
  - fedora
  - openstack
  - security
  - selinux
  - ubuntu

---
The blog posts have slowed down a bit lately because I've been heads down on a security project at work. I'm working with people in the OpenStack community to create a new Ansible role called [openstack-ansible-security][1]. The role aims to improve host security by using hardening standards to improve the configuration of various parts of the operating system.

This means applying security hardening to Ubuntu 14.04 systems since that's the only host operating system supported by [openstack-ansible][2] at the moment. I have plenty of experience with securing Red Hat-based systems like Red Hat Enteprise Linux, CentOS and Fedora; but Ubuntu is new territory entirely. The rest of this post is full of lessons learned along the way.

## Searching for hardening standards

Finding a complete hardening standard for Ubuntu 14.04 is challenging. The [Center for Internet Security][3] offers [Ubuntu security benchmarks][4] with two big caveats:

* There are very few controls to apply (relative to what's available for RHEL)
* The terms of use are highly restrictive (no derivative works allowed)

With that idea off the table, I examined the other options that meet Requirement 2.2 of PCI-DSS 3.1 [[PDF]][5]. Anther choice was [ISO 27002][6], but it's not terribly specific or easy to automate with scripts. The same goes for [NIST 800-53][7].

After plenty of searching, the decision was made to go forth with the [Security Technical Implementation Guide (STIG)][8] from the [Defense Information Systems Agency (DISA)][9] (part of the US Department of Defense). The STIGs aren't licensed and they're in the public domain. The only downside is that the closest STIG for use with Ubuntu 14.04 is the [RHEL 6 STIG][10].

Using the RHEL 6 STIG meant that plenty of things will need to be translated for the different tools, configuration files, and package names that come with Ubuntu. It was frustrating to search all over for a hardening standard that applies well to Ubuntu and comes with decent auditing tools, but this was the best we could find.

## Automatically starting daemons

The standard Ubuntu and Debian practice of automatically starting daemons has [perplexed me before][11] and it still continues to do so. Starting a daemon before I've had a chance to configure it makes little sense. The main argument is that the daemons come up with a highly secure configuration, so starting it automatically shouldn't be a big deal. I'd prefer to install a package, have a look at the configuration, alter the configuration, and then start the daemon. Also, it had better not start after a reboot unless I explicitly ask it to do so.

There are plenty of examples where automatically starting a daemon with its default configuration is a bad idea. Take the postfix package as an example. If you install the package in non-interactive mode (as Ansible does by default), postfix will come online wth the following configuration option set:

```
inet_interfaces = all
```

Since Ubuntu doesn't come with a firewall enabled by default, your postfix server is listening on all interfaces for mail immediately. The `mynetworks` configuration should prevent relaying, but any potential vulnerabilities in your postfix daemon are exposed to the network without your consent. I would prefer to configure postfix first before I ever allow it to run on my server.

## Verifying packages

Say what you will about RPM packages and the `rpm` command, but the verification portions of the `rpm` command are quite helpful. Here's an example of verifying the aide RPM in Fedora:

```
# rpm -Vv aide
.........  c /etc/aide.conf
.........  c /etc/logrotate.d/aide
.........    /usr/sbin/aide
.........    /usr/share/doc/aide
.........  d /usr/share/doc/aide/AUTHORS
.........  d /usr/share/doc/aide/COPYING
.........  d /usr/share/doc/aide/ChangeLog
.........  d /usr/share/doc/aide/NEWS
.........  d /usr/share/doc/aide/README
.........  d /usr/share/doc/aide/README.quickstart
.........    /usr/share/doc/aide/contrib
.........  d /usr/share/doc/aide/contrib/aide-attributes.sh
.........  d /usr/share/doc/aide/contrib/bzip2.sh
.........  d /usr/share/doc/aide/contrib/gpg2_check.sh
.........  d /usr/share/doc/aide/contrib/gpg2_update.sh
.........  d /usr/share/doc/aide/contrib/gpg_check.sh
.........  d /usr/share/doc/aide/contrib/gpg_update.sh
.........  d /usr/share/doc/aide/contrib/sshaide.sh
.........  d /usr/share/doc/aide/manual.html
.........  d /usr/share/man/man1/aide.1.gz
.........  d /usr/share/man/man5/aide.conf.5.gz
.........    /var/lib/aide
.........    /var/log/aide
```

If the verification finds that nothing in the package has changed, it won't print anything. I've added the `-v` here to ensure that everything is printed to the console. In the output, you can see that everything is checked. That includes configuration files, log directories, libraries, and documentation. If I change the content of the `aide.conf` by adding a comment, I see that change:

```
# echo "# Comment" >> /etc/aide.conf
# rpm -V aide
S.5....T.  c /etc/aide.conf
```

The `5` denotes that the MD5 checksum on the file has changed since the package was installed. What happens if I change the owner, group, and mode of the `aide.conf`?

```
# chown major:major /etc/aide.conf
# rpm -V aide
S.5..UGT.  c /etc/aide.conf
```

Now I have a `UG` there that denotes a user/group ownership change. Similar messages appear for changes to the permissions on files or directories. The `restorecon` command even lets you figure out when SELinux contexts have changed. If you set a file to have the wrong ownership or permission, one `rpm` command gets you back to normal:

```
# rpm --setperms --setugids aide
```

On the Ubuntu side, you can use the `debsums` package to help with some verification:

```
# debsums aide
/usr/bin/aide                                                                 OK
/usr/share/doc/aide/NEWS.Debian.gz                                            OK
/usr/share/doc/aide/changelog.Debian.gz                                       OK
...
# debums aide-common
/usr/bin/aide-attributes                                                      OK
/usr/bin/aide.wrapper                                                         OK
/usr/sbin/aideinit                                                            OK
...
```

But wait &#8212; where are the configuration files? Where are the log and library directories? If you type these commands on an Ubuntu system, you'll see that the configuration files and directories aren't checked. In addition, there's not a method for querying whether a particular file in a package has changed ownership or has had its mode changed. There's also no option to restore the right permissions and ownership after an errant `chown -R` or `chmod -R`.

## Managing AIDE

The [AIDE][12] package is critical for secure deployments since it helps administrators monitor for file integrity on a regular basis. However, Ubuntu ships with some interesting configuration files and wrappers for AIDE.

One of the unique configuration files is this one:

```
# cat /etc/aide/aide.conf.d/99_aide_root
/ Full
```

This causes AIDE to wander all over the system, indexing all types of files. It's best to limit AIDE to a small number of directories whenever possible so that the AIDE runs complete quickly and the database file remains relatively small. Plenty of disk I/O can be used during AIDE runs, so it's best to limit the scope.

Also, trying to initialize the database provides an unhelpful error:

```
# aide --init
Couldn't open file /var/lib/aide/please-dont-call-aide-without-parameters/aide.db.new for writing
```

That path doesn't exist, and I'm confused because I did pass a parameter to `aide`. Long story short, you must use the `aideinit` command to initialize the aide database. That's actually a bash script which then calls on `aide.wrapper` (another bash script) to actually run the `aide` binary for you. Better yet, `aideinit` is in `/usr/sbin` while `aide.wrapper` is in `/usr/bin`. This leads to plenty of confusion.

## Linux Security Modules

It's possible to run SELinux on Ubuntu, but the policies aren't as well maintained as they are on other distributions. AppArmor is the recommended LSM on Ubuntu, but it doesn't provide the granularity of SELinux. For example, SELinux confines almost every single process on a minimal Fedora system, but AppArmor confines almost nothing on a minimal Ubuntu-based system. AppArmor policies aren't terribly restrictive and it's possible to work around them due to their reliance on path names.

Fortunately, both LSM's provide decent coverage with virtual machines and containers (using libvirt's sVirt capability).

## Summary

The upside is that there is plenty of room for security improvements, especially around usability, in Ubuntu. Ubuntu-centric hardening standards are difficult to find and challenging to apply. Every distribution has its quirks and differences, but it seems like securing Ubuntu comes with more unusual hoops to jump through relative to Red Hat-based distributions, OpenSUSE, and even Arch.

I plan to open some bugs for some of these smaller issues in the coming days. However, some of the larger philosophical issues (like automatically starting daemons) will be tougher to tackle.

 [1]: http://specs.openstack.org/openstack/openstack-ansible-specs/specs/mitaka/security-hardening.html
 [2]: https://github.com/openstack/openstack-ansible
 [3]: http://www.cisecurity.org/
 [4]: https://benchmarks.cisecurity.org/downloads/browse/?category=benchmarks.os.linux.ubuntu
 [5]: https://www.pcisecuritystandards.org/documents/PCI_DSS_v3-1.pdf
 [6]: https://en.wikipedia.org/wiki/ISO/IEC_27002
 [7]: https://en.wikipedia.org/wiki/NIST_Special_Publication_800-53
 [8]: https://public.cyber.mil/stigs/
 [9]: http://www.disa.mil/
 [10]: https://www.stigviewer.com/stig/red_hat_enterprise_linux_6/
 [11]: /2014/06/26/install-debian-packages-without-starting-daemons/
 [12]: http://aide.sourceforge.net/
