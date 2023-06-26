---
aliases:
- /2012/06/03/fedora-17-xva-ready-to-import-into-xenserver/
author: Major Hayden
date: 2012-06-04 02:25:45
featured_image: /wp-content/uploads/2012/06/xen_logo_small.png
tags:
- fedora
- xen
- xenserver
title: Fedora 17 XVA ready to import into XenServer
---

[<img src="/wp-content/uploads/2012/06/xen_logo_small-300x133.png" alt="Xen Logo" title="Xen Logo" width="300" height="133" class="alignright size-medium wp-image-3397" srcset="/wp-content/uploads/2012/06/xen_logo_small-300x133.png 300w, /wp-content/uploads/2012/06/xen_logo_small.png 800w" sizes="(max-width: 300px) 100vw, 300px" />][1]After I [wrote a post][2] about my kickstart update for Fedora 17, I asked if anyone wanted a XVA export of a working Fedora 17 instance. Without further ado, here's the bzip2-compressed XVA file ready to be decompressed and imported into XenServer:

  * [F17.xva.bz2][3] (221MB)

The kickstart used to generate the XVA can be [found on GitHub][4]. To import this virtual machine export, use XenCenter or ssh to your XenServer instance and run:

```
xe vm-import filename=F17.xva
```


The VM should try to get its network configuration via DHCP and you can log in as **root** with the password **qwerty**. It should go without saying, but you ought to change that password at your earliest opportunity. (It's #20 on the [New York Times' list of simplest passwords][5].)

 [1]: /wp-content/uploads/2012/06/xen_logo_small.png
 [2]: /2012/05/30/fedora-17-released-xenserver-kickstarts-updated/
 [3]: http://c3364925.r25.cf0.rackcdn.com/F17.xva.bz2
 [4]: https://github.com/rackerhacker/kickstarts/blob/master/fedora17-minimal-xenserver6.ks
 [5]: http://www.nytimes.com/2010/01/21/technology/21password.html