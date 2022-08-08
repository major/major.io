---
title: Hunting down annoying web spiders
author: Major Hayden
date: 2007-09-08T22:16:07+00:00
url: /2007/09/08/hunting-down-annoying-web-spiders/
dsq_thread_id:
  - 3679025841
tags:
  - web

---
We all enjoy having the GoogleBot and other search engine robots index our sites as it brings us higher on search engines, but it's annoying when some user scrapes your site for their own benefit. This is especially bad on forum sites as they're always a target, and it can severely impact server performance.

To hunt down these connections when the spidering is happening, simply run this command:

`netstat -plan | grep :80 | awk '{print $5}' | sed 's/:.*$//' | sort | uniq -c | sort -rn`

The IP's that are making the most connections will appear at the top of the list, and from there, you can find out which unwelcome spider is scraping your site.
