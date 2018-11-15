---
title: 'Reprint: Stop Disabling SELinux!'
author: Major Hayden
type: post
date: 2013-04-19T05:52:23+00:00
url: /2013/04/19/reprint-stop-disabling-selinux/
dsq_thread_id:
  - 3642807229
categories:
  - Blog Posts
tags:
  - centos
  - fedora
  - general advice
  - red hat
  - security
  - selinux
  - writing

---
_This article appeared in [SC Magazine][1] and I've posted it here as well. For those of you who were left wanting more from my [previous SELinux post][2], this should help. If it doesn't help, leave a comment. ;)_

* * *

The push to cloud transforms the way we apply information security principles to systems and applications. Perimeters of the past, secured heavily with traditional network devices in the outermost ring, lose effectiveness day by day. Shifting the focus to "defense in depth" brings the perimeter down to the individual cloud instances running your application. Security-Enhanced Linux, or SELinux, forms an effective part of that perimeter.

SELinux operates in the realm of mandatory access control, or MAC. The design of MAC involves placing constraints on what a user (a _subject_) can do to a particular object (a _target_) on the system. In contrast, discretionary access control, or DAC, allows a user with certain access to use discretion to limit or allow access to certain files, directories, or devices. You can set any file system permissions that you want but SELinux can override them with ease at the operating system level.

Consider a typical server running a web application. An attacker compromises the web application and executes malicious code via the web server daemon itself. SELinux has default policies that prevent the daemon from initiating communication on the network. That limits the attacker’s options to attack other services or servers.

In addition, SELinux sets policies on which files and directories the web server can access, regardless of any file system permissions. This protection limits the attacker’s access to other sensitive parts of the file system even if the administrator set the files to be readable to the world.

This is where SELinux shines. Oddly enough, this is the point where many system administrators actually _disable SELinux_ on their systems.

Troubleshooting these events, called AVC denials, without some helpful tools is challenging and frustrating. Each denial flows into to your audit log as a cryptic message. Most administrators will check the usual suspects, like firewall rules and file system permissions. As frustration builds, they disable SELinux and notice that their application begins working as expected. SELinux remains disabled and hundreds of helpful policies lie dormant solely because one policy caused a problem.

Disabling SELinux without investigation frustrated me to the point where I started a site at [stopdisablingselinux.com][3]. The site is a snarky response to Linux administrators who reach for the disable switch as soon as SELinux gets in their way.

All jokes aside, here are some helpful tips to use SELinux effectively:

**Use the _setroubleshoot_ helpers to understand denials**

Working through denials is easy with the _setroubleshoot-server_ package. When a denial occurs, you still receive a cryptic log message in your audit logs. However, you also receive a message via syslog that is very easy to read. Your server can email you these messages as well. The message contains guidance about adjusting SELinux booleans, setting contexts, or generating new SELinux policies to work around a really unusual problem. When I say guidance, I mean that the tools give you commands to copy and paste to adjust your policies, booleans and contexts.

**Review SELinux booleans for quick adjustments**

Although the myriad of SELinux user-space tools isn’t within the scope of this article, _getsebool_ and _togglesebool_ deserve a mention. Frequently adjusted policies are controlled by booleans that are toggled on and off with _togglesebool_. Start with _getsebool –a_ for a full list of booleans and then use _togglesebool_ to enable or disable the policy.

**Quickly restore file or directory contexts**

Shuffling files or directories around a server can cause SELinux denials due to contexts not matching their original values. This happens to me frequently if I move a configuration file from one system to another. Correcting the context problem involves one of two simple commands. The _restorecon_ command applies the default contexts specific to the file or directory. If you have a file in the directory with the correct context, use _chcon_ to fix the context on the wrong file by giving it the path to the file with the correct context.

Here are some additional links with helpful SELinux documentation:

  * [SELinux Project Wiki][4]
  * [Red Hat Enterprise Linux 6 SELinux Guide][5]
  * [Dan Walsh's Blog][6]

 [1]: http://www.scmagazine.com.au/News/340475,stop-disabling-selinux.aspx
 [2]: /2013/04/15/seriously-stop-disabling-selinux/
 [3]: http://stopdisablingselinux.com
 [4]: http://selinuxproject.org/page/Main_Page
 [5]: https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security-Enhanced_Linux/
 [6]: http://danwalsh.livejournal.com/
