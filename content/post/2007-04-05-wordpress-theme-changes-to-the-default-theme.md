---
title: WordPress theme changes to the default theme
author: Major Hayden
type: post
date: 2007-04-05T23:14:49+00:00
url: /2007/04/05/wordpress-theme-changes-to-the-default-theme/
dsq_thread_id:
  - 3679058234
tags:
  - web

---
This is tremendously aggravating. I find that this blog mysteriously changes back to the default WordPress theme without warning at completely random times. After turning on lots of logging, I found that the GoogleBot and regular visitors seemed to be causing it, but they caused it when they made completely normal requests from the site.

After getting flustered, I realized a dirty hack was in order. I made a new theme folder called 'default-original' and moved the contents of the default theme into it. After that, I copied the contents of my desired theme folder into the default folder. After waiting a few hours, the magic happened and the theme was reset. But alas - the default theme is now my desired theme.

Dirty hacks sometimes work the best. :-)
