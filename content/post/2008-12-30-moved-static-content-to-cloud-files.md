---
title: Moved static content to Cloud Files
author: Major Hayden
type: post
date: 2008-12-30T05:53:08+00:00
url: /2008/12/30/moved-static-content-to-cloud-files/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642805463
categories:
  - Blog Posts
tags:
  - cloud files
  - wordpress

---
I've moved all of this blog's CSS, javascript, and most of the images to Rackspace's [Cloud Files][1] so they can be served via the [Limelight CDN][2]. So far, this has [cut the load times in half][3].

Most of the edits aren't supported by WordPress, so I ventured into the source code for my plugins as well as my theme and adjusted the links to point to the mirrored files on the Cloud Files service.

 [1]: http://www.mosso.com/cloudfiles.jsp
 [2]: http://www.limelightnetworks.com/
 [3]: http://cdn.cloudfiles.mosso.com/c8031/rackerhacker_static_content_cdn_psinet_london.png
