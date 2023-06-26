---
aliases:
- /2007/08/02/add-custom-rules-to-the-plesk-firewall/
author: Major Hayden
date: 2007-08-03 02:54:01
tags:
- plesk
- security
title: Add custom rules to the Plesk firewall
---

Plesk has a (somewhat annoying) default firewall configuration that you can adjust from within the Plesk interface. However, if you want to add additional rules, you may find that you can't add the rules you want from the interface. If you add them from the command line, Plesk will overwrite them when it feels the urge, even if you run `service iptables save` as you're supposed to.

You can override this by making `/etc/sysconfig/iptables` immutable with chattr. Just run the following:

`# chattr +i /etc/sysconfig/iptables`

Now, Plesk can't adjust your iptables rules without your intervention. Well, that is until SWSoft figures out how to run chattr when Plesk can't edit certain configuration files. :-)