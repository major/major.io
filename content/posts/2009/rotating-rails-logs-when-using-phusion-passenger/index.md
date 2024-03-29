---
aliases:
- /2009/06/26/rotating-rails-logs-when-using-phusion-passenger/
author: Major Hayden
date: 2009-06-26 15:09:54
tags:
- apache
- logrotate
- passenger
- rails
title: Rotating rails logs when using Phusion Passenger
---

I found a [great post][1] on [Overstimulate][2] about handling the rotation of rails logs when you use Phusion Passenger. Most of the data for your application should end up in the apache logs, but if your site is highly dynamic, you may end up with a giant production log if you're not careful.

Toss this into /etc/logrotate.d/yourrailsapplication:

<pre lang="html">/var/www/yourrailsapp/log/*.log {
  daily
  missingok
  rotate 30
  compress
  delaycompress
  sharedscripts
  postrotate
    touch /var/www/yourrailsapp/tmp/restart.txt
  endscript
}</pre>

For a detailed explanation, [see the post][1] on [Overstimulate][2].

 [1]: http://overstimulate.com/articles/logrotate-rails-passenger
 [2]: http://overstimulate.com/