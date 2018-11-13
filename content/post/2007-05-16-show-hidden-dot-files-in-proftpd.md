---
title: Show hidden dot files in proftpd
author: Major Hayden
type: post
date: 2007-05-17T01:46:59+00:00
url: /2007/05/16/show-hidden-dot-files-in-proftpd/
dsq_thread_id:
  - 3642766762
tags:
  - ftp

---
If you can't see hidden files in proftpd (the files beginning with a dot, like .htaccess), you can enable the option in your client. However, you can force the files to be displayed in almost all clients with a server wide variable in your proftpd.conf:

`ListOptions -a`

Make sure to restart proftpd afterwards and re-connect to the FTP server to see the changes.
