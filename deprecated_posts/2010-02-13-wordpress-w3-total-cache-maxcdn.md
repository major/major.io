---
title: WordPress + W3 Total Cache + MaxCDN How-To
author: Major Hayden
date: 2010-02-14T03:56:30+00:00
url: /2010/02/13/wordpress-w3-total-cache-maxcdn/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642806003
tags:
  - cdn
  - dns
  - linux
  - optimization
  - performance
  - wordpress

---
It's no secret that I'm a big fan of [WordPress][1] as a blog and CMS platform. While it does have its problems, it's relatively simple to set up, it's extensible, and - when properly configured - it has great performance. The [WP Super Cache][2] plugin has been a staple on my WordPress blogs for quite some time and it has solved almost all of my performance problems.

However, when you load up quite a few plugins or a heavy theme, the performance will dip due to the increased number of stylesheets, javascript files, and images. You can compress and combine the stylesheets and javascript to decrease load times, but this may not get the performance to a level you like.

I was in this situation and I found a great solution: the [W3 Total Cache][3] plugin and the [MaxCDN][4] service.

To get started, [visit MaxCDN's site][4] and set up an account. Their current promotion gives you 1TB of CDN bandwidth for one year for $10 (regularly $99). Once you sign up, do the following:

  * Click **Manage Zones**
  * Click **Create pull zone**

At this point, you'll see a list of form fields to complete:

  * Enter an alias for the pull zone name
  * The origin server URL is the URL that's normally used to access your site (i.e. rackerhacker.com)
  * The custom CDN domain is the URL you want to use for your CDN (i.e. cdn.rackerhacker.com)
  * The label can be anything you'd like to use to remember which zone is which
  * Enabling compression is generally a good idea

Once you save the zone, MaxCDN will give you a new domain name. You'll want to create a CNAME record that points from your CDN URL (for me, that's cdn.rackerhacker.com) to the really long URL that MaxCDN provides.

<strong style="color: #D42020;">STOP HERE:</strong> Ensure that all of your DNS servers are replying with the CNAME record before you continue with the W3 Total Cache installation and CDN setup. If you proceed without waiting for that, some of your blog's visitors will get errors when they try to load content via your CDN domain.

You're ready for W3 Total Cache now. Install the plugin within your WordPress installation and activate it. Hop into the settings for the plugin and make these adjustments:

  * Enable **Page Caching** and set it to **Disk (enhanced)**
  * Enable **Minify** and set it to **Disk**
  * Enable **Database Caching** and set it to **Disk**
  * Leave the CDN disabled for now, but flip the **CDN Type** to **Origin Pull (Mirror)**
  * Press **Save changes**

Click **CDN Settings** at the top of the page and configure the CDN:

  * Enter your CDN domain (for me, it's cdn.rackerhacker.com) in the top form field
  * Leave the other options as they are by default and click **Save changes**

W3 Total Cache should prompt you to clear out your page cache, and that would be recommended at this step. If you fully reload your blog's main page in your browser (may require you to hold SHIFT while you click reload/refresh) and check the page source, you should see your CDN URL appear for some of the javascript or CSS files.

You may discover that some CSS files, stylesheets, or images aren't being loaded via the CDN automatically. Luckily, that's an easy fix. Under the **Minify Settings** section of the W3 Total Cache plugin settings, scroll to the very bottom. Add in your javascript or CSS files via the form fields at the bottom and the plugin should handle the minifying (is that even a word?) and the CDN URL rewriting for you.

Further reading:

  * [MaxCDN WordPress Integration Overview][5]
  * [W3 Total Cache plugin page at wordpress.org][3]
  * [W3 Total Cache main site][6]

 [1]: http://wordpress.org/
 [2]: http://wordpress.org/extend/plugins/wp-super-cache/
 [3]: http://wordpress.org/extend/plugins/w3-total-cache/
 [4]: http://www.maxcdn.com/
 [5]: http://www.maxcdn.com/wordpress-cdn-module.php
 [6]: http://www.w3-edge.com/wordpress-plugins/w3-total-cache/
