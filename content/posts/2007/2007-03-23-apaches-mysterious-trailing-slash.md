---
title: Apache’s mysterious trailing slash
author: Major Hayden
date: 2007-03-23T13:20:27+00:00
url: /2007/03/23/apaches-mysterious-trailing-slash/
dsq_thread_id:
  - 3679061133
tags:
  - web

---
You may find that some sites do not work well if you omit a trailing slash on the URL. For example, if you have a directory on domain.com called "news", the following two URL's should take you to the same place:

http://domain.com/news

http://domain.com/news/

If you find that they do not take you to the same place, be sure that the mod_dir ([Apache 1][1] or [Apache 2][2]) module is being loaded in Apache. If that module is being loaded, and you're still having problems, make sure mod_rewrite is loaded as well.

If none of that works, make sure that there is no ErrorDocument 301 or ErrorDocument 302. Should either of those exist, promptly slap the developer/sysadmin that enabled those options. Apache will do a 301 redirect when the trailing slash is missing so that the user will be directed to the correct location, and if there is an ErrorDocument 301, this error document will always be presented rather than the proper redirection to the directory on your site.

 [1]: http://httpd.apache.org/docs/1.3/mod/mod_dir.html
 [2]: http://httpd.apache.org/docs/2.0/mod/mod_dir.html
