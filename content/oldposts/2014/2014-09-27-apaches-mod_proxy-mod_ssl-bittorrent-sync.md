---
title: Apache’s mod_proxy, mod_ssl, and BitTorrent Sync
author: Major Hayden
date: 2014-09-28T02:08:18+00:00
url: /2014/09/27/apaches-mod_proxy-mod_ssl-bittorrent-sync/
dsq_thread_id:
  - 3642807763
tags:
  - apache
  - fedora
  - linux
  - security
  - ssl
  - sync

---
![1]

[BitTorrent Sync][2] allows you to keep files synchronized between multiple computers or mobile devices. It's a handy way to do backups, share files with friends, or automate the movement of data from device to device. It comes with a web frontend, called the Web UI, that allows for connections over HTTP or HTTPS.

Using HTTP across the internet to administer Sync seems totally absurd, so I decided to enable HTTPS. I quickly realized two things:

  * My SSL certificates were now specified in Apache and Sync
  * Sync's Web UI is relatively slow with SSL enabled (especially over higher latency links)

I really wanted to keep things simple by wedging Sync into my existing Apache configuration using mod_proxy.  That was easier said than done since the Web UI has some hard-coded paths for certain assets, like CSS and Javascript.  After quite a bit of trial end error, this configuration works well:

```
ProxyPass /btsync http://127.0.0.1:8888
ProxyPassReverse /btsync http://127.0.0.1:8888
ProxyHTMLURLMap http://127.0.0.1:8888 /btsync
Redirect permanent /gui /btsync/gui
```


The _ProxyPass_ and _ProxyPassReverse_ lines tell Apache where to proxy the requests and it also tells Apache to make requests _on behalf of_ the browser making the request. The _ProxyHTMLURLMap_ directive tells Apache that any requests to `/btsync` from a client browser should be translated as a request to the root directory (`/`) of the Web UI. The last line redirects hard-coded requests to `/gui` up to `/btsync/gui` instead.

When your configuration is in place, be sure to run a configuration check (`httpd -S`) and reload the Apache daemon. If you'd like to access your application at a different URI, just replace `/btsync` in the example configuration with that URI.

Once all this is done, I'm able to access Sync at `https://example.com/btsync` and Apache handles all of the backend requests properly. On some distributions, you may find that _mod\_proxy\_html_ isn't installed by default. You'll need to install it if you want to use _ProxyHTMLURLMap_ in your configuration. For Fedora users, just install it via yum:

```
yum install mod_proxy_html
```


<em style="font-size: 10px;">Photo: <a href="http://picjumbo.com/old-vintage-railway/">Old Vintage Railway</a> by <a href="http://twitter.com/viktorhanacek">Viktor Hanacek</a></em>

 [1]: /wp-content/uploads/2014/09/picjumbo.com_IMG_6970-e1411869964358.jpg
 [2]: https://www.getsync.com/
