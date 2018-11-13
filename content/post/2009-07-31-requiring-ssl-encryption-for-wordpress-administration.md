---
title: Requiring SSL encryption for WordPress administration
author: Major Hayden
type: post
date: 2009-07-31T13:13:26+00:00
url: /2009/07/31/requiring-ssl-encryption-for-wordpress-administration/
dsq_thread_id:
  - 3642805686
categories:
  - Blog Posts
tags:
  - php
  - security
  - ssl
  - wordpress

---
I was digging around for [WordPress][1] plugins last night that would allow me to secure the administrative login page for my WordPress installations. Most of the plugins are only compatible with WordPress 2.7.x or earlier, so I was a little concerned about them working with WordPress 2.8.2.

Then I stumbled upon the [WordPress documentation][2] that shows you how to require SSL with no plugins at all. If you're using WordPress 2.6+, you can use these super-simple instructions:

Require encryption just for the /wp-admin/ login, but leave the rest of the administrative area on HTTP:

```
# Add this line to wp-config.php
define('FORCE_SSL_LOGIN', true);</pre>

To encrypt the login and the entire administrative area:

```
# Add this line to wp-config.php
define('FORCE_SSL_ADMIN', true);</pre>

Of course, for this to work, you'll need virtual hosts on ports 80 and 443 for your blog. Also, you'll need an SSL certificate for your blog. You can snag one from a [reputable provider][3] or [make your own][4].

 [1]: http://wordpress.org/
 [2]: http://codex.wordpress.org/Administration_Over_SSL
 [3]: https://ssl.trustwave.com/solutions-overview.php
 [4]: http://rackerhacker.com/2007/08/02/generate-self-signed-certificate-and-key-in-one-line/
