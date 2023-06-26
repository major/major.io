---
aliases:
- /2008/01/31/high-iowait-on-rhel-4-with-plesk-and-spamassassin/
author: Major Hayden
date: 2008-01-31 18:38:58
tags:
- iowait
- mail
- plesk
- spamassassin
title: High iowait on RHEL 4 with Plesk and SpamAssassin
---

One of my biggest complaints on RHEL 4 is the large resource usage by the version of SpamAssassin that is installed. When it runs, it uses a ton of CPU time and causes a lot of disk I/O as well. When running top, you may see multiple spamd processes. For a high-volume e-mail server (like the one I administer), this is simply unacceptable.

I decided to do something about it, and here are the steps:

**First,** you will need two RPMs:

Latest [SpamAssassin RPM from Dag][1]

The [psa-spamassassin RPM from SWSoft/Parallels][2].

Once you have them both on the server, install the new SpamAssassin package from Dag:

`# rpm -Uvh spamassassin-(version).el4.rf.(arch).rpm`

At this point, Plesk's spamassassin scripts will be non-functional, but the next step will fix it:

`# rpm -Uvh --force psa-spamassassin-(version).(arch).rpm`

**NOTE: DO NOT REMOVE the psa-spamassassin RPM. This will begin stripping your system of all SpamAssassin configurations and it cannot be reversed!**

Plesk's SpamAssassin scripts have been restored at this point in the process. Now, we need to do the part that really makes SpamAssassin work efficiently:

`# sa-update; sa-compile;`

This will update the SpamAssassin rules, and it will compile the rules with re2c (you may also need to [get this RPM from Dag][3]). This compilation means less disk access, and less CPU time being used to process e-mails.

To activate the compiled rules within SpamAssassin, uncomment the plugin line in /etc/mail/spamassassin/v320.pre:

`# Rule2XSBody - speedup by compilation of ruleset to native code<br />
#<br />
loadplugin Mail::SpamAssassin::Plugin::Rule2XSBody`

Please bear in mind that this process is done _at your own risk_. This may cause issues getting support from SWSoft or your hosting company. This has been tested on Red Hat Enterprise Linux 4 64-bit with Plesk 8.1.1, 8.2.0, and 8.2.1 with SpamAssassin 3.2.3 and 3.2.4.

 [1]: http://dag.wieers.com/rpm/packages/spamassassin/
 [2]: http://autoinstall.plesk.com/
 [3]: http://dag.wieers.com/rpm/packages/re2c/