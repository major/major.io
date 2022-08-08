---
title: Plesk Professional Website Editor hangs at login
author: Major Hayden
date: 2008-03-13T18:11:57+00:00
url: /2008/03/13/plesk-professional-website-editor-hangs-at-login/
dsq_thread_id:
  - 3642771017
tags:
  - networking
  - plesk

---
One of my biggest Plesk gripes is dealing with the Plesk Professional Website Editor. One of the most common occurrences with PPWSE is that it hangs when you attempt to log into the server. Normally, this happens when a server is behind a firewall, and it is using private IP's.

Plesk will actually query the DNS for the domain (rather than simply connecting to the localhost), try to reach the public IP, and the traffic will be blocked by the firewall. This creates a login session that appears to hang, and then it shows "FTP: not connected" in the interface.

The fix is actually quite easy:

1) Be sure that the ftp.domain.com CNAME/A record exists

2) Add a line to /etc/hosts that forces ftp.domain.com to resolve to the proper private IP address.

The third item should be to stop using PPWSE, but that's the hardest one to work out. I'd recommend using something like [TextMate][1] on a [Mac][2] along with [Transmit][3], but you can get some good results out of Dreamweaver as well. Whatever you do, don't use Contribute.

 [1]: http://macromates.com/
 [2]: http://www.apple.com/macbookpro/
 [3]: http://www.panic.com/transmit/
