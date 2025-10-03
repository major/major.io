---
aktt_notify_twitter:
- false
aliases:
- /2010/02/28/system-administration-inspiration-if-its-broken-break-it-a-little-more/
author: Major Hayden
date: 2010-02-28 16:47:16
tags:
  - advice
  - sysadmin
title: 'System Administration Inspiration: If it’s broken, break it a little more'
---

Earlier this year, [I started a series of posts][1] to encourage systems administrators to refine their troubleshooting abilities. This is the second post in that series.

Almost every system administrator has found themselves in a situation where they're confronted with a server which has a problem. However, if you're not the primary administrator for the server, you may not always know what has changed recently or you may not be aware of changes in the server's environment. In these situations, if the fix isn't obvious, try going through these steps:

**Localize the problem to a specific daemon or service**

In the case of a problem where a website isn't loading properly, is it a problem with the web server itself? Could something other than the actual web server daemon be having an issue?

As an example, consider a ruby on rails application which runs through apache's mod\_proxy\_balancer and queries data from MySQL. If any of those individual puzzle pieces were not functioning correctly, you'd get a different result. A downed MySQL instance could make the application throw errors or appear to be unresponsive. If the mongrel cluster had failed, apache might be returning internal server errors. Your browser might return a connection refused if apache was down. These are all relatively easy to determine.

What if you are unable to determine which daemon is causing the problem?

**If it's broken, break it a little more**

Let's say that you've reviewed the process list and all of the appropriate daemons appear to be running. However, the website is still not loading properly. What do you do? Bring down a service and try again. Did something change? Did a new error appear? If not, bring that daemon back up and try taking down one of the other ones.

I've also had some good results by making small adjustments in the web server's configuration file. If you have a virtual host that isn't returning the correct data, try commenting it out temporarily. For rewrite rules, try removing them temporarily or strip them down to a more basic form. Test again, and then begin adding lines back incrementally. As much as a single period or quotation mark can derail a perfectly good set of rewrite rules.

In short - try to think outside the box when you're troubleshooting a difficult issue on an unfamiliar system. Always remember to back up your configurations before making changes and ensure your daemons will start properly if you bring them down.

 [1]: http://rackerhacker.com/2010/01/03/a-new-year-system-administrator-inspiration/
