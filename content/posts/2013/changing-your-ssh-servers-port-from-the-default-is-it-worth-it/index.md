---
aliases:
- /2013/05/14/changing-your-ssh-servers-port-from-the-default-is-it-worth-it/
author: Major Hayden
date: 2013-05-15 04:43:41
tags:
- command line
- fedora
- advice
- linux
- networking
- networking
- red hat
- security
- ssh
- sysadmin
- virtualization
- web
title: 'Changing your ssh server’s port from the default: Is it worth it?'
description: Moving ssh to a port other than port 22 can make it slightly more difficult to attack your server. 🛡️
---

Changing my ssh port from the default port (22) has been one of my standard processes for quite some time when I build new servers or virtual machines. However, I see arguments crop up regularly about it (like [this reddit thread][1] or [this other one][2]).

Before I go any further, let's settle the "security through obscurity" argument. _(This could probably turn into its own post but I'll be brief for now.)_ Security should always be applied in layers. This provides multiple levels of protection from initial attacks, like information gathering attempts or casual threats against known vulnerabilities. In addition, these layers of security should be applied **within** the environment so that breaking into one server after getting a pivot point in the environment should be just as difficult (if not more difficult) than the original attack that created the pivot point. If "security through obscurity" tactics make up _one layer_ of a _multi-layered solution_, I'd encourage you to obscure your environment as long as it doesn't [affect your availability][3].

The key takeaway is:

> Security through obscurity is effective if it's one layer in a multi-layer security solution

Let's get back to the original purpose of the post.

**The biggest benefit to changing the port is to avoid being seen by casual scans.** The vast majority of people hunting for any open ssh servers will look for port 22. Some will try the usual variants, like 222 and 2222, but those are few and far between. I ran an experiment with a virtual machine exposed to the internet which had sshd listening on port 22. The server stayed online for one week and then I changed the ssh port to 222. **The number of attacks dropped by 98%.** Even though this is solely empirical evidence, it's clear that moving off the standard ssh port reduces your server's profile.

If it's more difficult to scan for your ssh server, your chances of being attacked with an ssh server exploit are reduced. A determined attacker can still find the port if they know your server's IP address via another means (perhaps via a website you host) and they can launch attacks once they find it. Paranoid server administrators might want to check into [port knocking][4] to reduce that probability even further.

Remembering the non-standard ssh port can be annoying, but if you have a standard set of workstations that you use for access your servers, just utilize your `~/.ssh/config` file to specify certain ports for certain servers. For example:

```
Host *.mycompany.com
  Port 4321

Host nonstandard.mypersonalstuff.com
  Port 2345

Host *.mypersonalstuff.com
  Port 5432
```


If you run into SELinux problems with a non-standard ssh port, there are [plenty of guides on this topic.][5]. The `setroubleshoot-server` package helps out with this as well.

```
# semanage port -a -t ssh_port_t -p tcp 4321
# semanage port -l | grep ssh
ssh_port_t                     tcp      4321,22
```


Here is my list of ssh lockdown practices when I build a new server:

  * Update the ssh server package and ensure that automatic updates are configured
  * Enable SELinux and allow a non-standard ssh port
  * Add my ssh public key to the server
  * Disable password logins for ssh
  * Adjust my `AllowUsers` setting in sshd_config to only allow my user
  * Disable root logins
  * For servers with sensitive data, I install [fail2ban][6]

 [1]: http://redd.it/1ebe0d
 [2]: http://redd.it/fnz1h
 [3]: http://security.blogoverflow.com/2012/08/confidentiality-integrity-availability-the-three-components-of-the-cia-triad/
 [4]: https://wiki.archlinux.org/index.php/Port_Knocking
 [5]: /2011/09/15/receive-e-mail-reports-for-selinux-avc-denials/
 [6]: http://www.fail2ban.org/
