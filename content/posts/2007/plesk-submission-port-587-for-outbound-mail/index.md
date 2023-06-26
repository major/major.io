---
aliases:
- /2007/05/15/plesk-submission-port-587-for-outbound-mail/
author: Major Hayden
date: 2007-05-15 14:28:17
tags:
- mail
- plesk
title: Plesk submission port (587) for outbound mail
---

If you can't send mail via port 25 due to blocks imposed by your ISP, you can enable the submission port within Plesk pretty easily. There's two methods:

The iptables way:

```
iptables -t nat -A PREROUTING -p tcp --dport 587 -i eth0 -j REDIRECT --to-ports 25
```

The xinetd way (recommended):

```
# cd /etc/xinetd.d
# cp smtp_psa smtp_additional
# vi smtp_additional
```

Make the first line say "service submission" and save the file. Then restart xinetd:

```
/etc/rc.d/init.d/xinetd restart
```

**This is no longer needed in Plesk 8.4. To enable the submission port in Plesk 8.4, log into the Plesk interface as the Administrator, click Server and click Mail.**