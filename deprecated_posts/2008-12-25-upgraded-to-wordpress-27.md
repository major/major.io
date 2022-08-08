---
title: Upgraded to WordPress 2.7
author: Major Hayden
date: 2008-12-26T03:45:39+00:00
url: /2008/12/25/upgraded-to-wordpress-27/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642805466
tags:
  - blog
  - wordpress

---
I've upgraded the blog successfully to [WordPress 2.7][1] (with a bit of frustration). When I attempted the upgrade, I received this error:

`Call to undefined method wpdb::has_cap() in schema.php on line 22`

Even though I followed the instructions on the WordPress site, and I disabled all of my plugins, the error kept appearing. The only parts of the site that remained unchanged after the upgrade were the `wp-config.php` page and the `wp-content` directory. I merged the changes in wp-config.php, but the error was still present.

In frustration, I renamed the wp-content directory to a temporary name and uploaded the `wp-content` provided from the WordPress tarball. The upgrade completed without a problem! I deleted the new `wp-content` directory, put the old `wp-content` directory back in place, and WordPress sprang to life!

It's certainly possible that a WordPress plugin blocked the upgrade process even though it was disabled in the database.

 [1]: http://wordpress.org/
