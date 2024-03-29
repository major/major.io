---
aliases:
- /2007/02/27/disabling-sslv2-in-plesk/
author: Major Hayden
date: 2007-02-27 18:17:02
tags:
- plesk
- security
- web
title: Disabling SSLv2 in Plesk
---

To disable SSLv2 server-wide on a Plesk server, add this in your /etc/httpd/conf.d/ssl.conf:

```
SSLCipherSuite ALL:!ADH:!LOW:!SSLv2:!EXP:+HIGH:+MEDIUM
SSLProtocol all -SSLv2
```

Put the directive very high in the file, outside the VirtualHost directive, preferably right below the Listen directive. This will work for all SSL VirtualHosts.

[How can I ensure that Apache does not allow SSL 2.0 protocol that has known weaknesses?][1]

 [1]: http://kb.swsoft.com/en/1763