---
title: Fix MacFusion on Snow Leopard
author: Major Hayden
type: post
date: 2009-08-28T16:21:23+00:00
url: /2009/08/28/fix-macfusion-on-snow-leopard/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642805719
categories:
  - Blog Posts
tags:
  - ftp
  - mac
  - macfusion
  - snow leopard
  - ssh

---
**Running OS X 10.6.3?** William Fennie [found a fix on Google Groups][1].

First off, credit for this fix on **OS X 10.6.2** goes to [Geoff Watts][2] from his [two][3] [tweets][4].

If you're using Snow Leopard, you'll find that the current version of MacFusion refuses to complete a connection to a remote server. You can fix this in two steps:

First, quit MacFusion.

Second, open System Preferences and then open the MacFUSE pane. Check the "Show Beta Versions" box and click "Check For Updates". Go ahead and update MacFUSE.

Third, open up a terminal and do the following:

```


Your MacFusion installation should now be working on Snow Leopard. I've tested SSH and FTP connectivity so far, and they both appear to be working. Thanks again to Geoff for the fix!

 [1]: http://groups.google.com/group/macfuse/browse_thread/thread/3c611784177843f0/3f02a6efd38f4b30?show_docid=3f02a6efd38f4b30
 [2]: https://twitter.com/geoffwatts
 [3]: http://twitter.com/geoffwatts/status/3605414263
 [4]: http://twitter.com/geoffwatts/status/3605464669
