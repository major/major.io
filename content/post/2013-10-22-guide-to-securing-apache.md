---
title: Guide to securing apache
author: Major Hayden
type: post
date: 2013-10-22T12:30:51+00:00
url: /2013/10/22/guide-to-securing-apache/
dsq_thread_id:
  - 3642807412
categories:
  - Blog Posts
tags:
  - apache
  - infosec
  - security
  - web

---
I stumbled upon a helpful guide to securing an apache server via Reddit's [/r/netsec subreddit][1]. Without further ado, here's a link to the guide:

  * [Apache web server hardening & security guide][2]

The guide covers the simplest changes, like reducing ServerTokens output and eliminating indexes, all the way up through configuring mod_security and using the [SpiderLabs GitHub repository][3] to add additional rules.

If you'd like a more in-depth post about installing mod_security, I'd recommend [this one from Tecmint][4].

Oh, and as always, don't forget about SELinux. :)

**UPDATE:** Thanks to [@matrixtek][5] for mentioning [Mozilla's recommendations specific to TLS][6].

 [1]: http://reddit.com/r/netsec
 [2]: http://www.chandank.com/webservers/apache/apache-web-server-hardening-security
 [3]: https://github.com/SpiderLabs/owasp-modsecurity-crs/
 [4]: http://www.tecmint.com/protect-apache-using-mod_security-and-mod_evasive-on-rhel-centos-fedora/
 [5]: http://twitter.com/matrixtek
 [6]: https://wiki.mozilla.org/Security/Server_Side_TLS
