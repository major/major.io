---
title: 'Raising MaxClients?  Change ServerLimit.'
author: Major Hayden
type: post
date: 2006-12-27T14:36:40+00:00
url: /2006/12/27/raising-maxclients-change-serverlimit/
dsq_thread_id:
  - 3643953969
tags:
  - web

---
Remember, if you raise MaxClients for an MPM in Apache, you must raise the ServerLimit directive, which is normally set to 256 on most servers.Â  The ServerLimit maximum is always obeyed, no matter what MaxClients says. For example, if MaxClients is set to 500 and ServerLimit is 256 (or it is unspecified), then Apache can only serve 256 clients at a time.

Important items to remember:

  * Only add ServerLimit in the actual MPM configuration section itself.
  * Increase the MaxClients/ServerLimit in a sane manner - make small increments and test.
  * Keep in mind that 500 concurrent requests can use 75% or more of modern CPU's and upwards of 1.5GB of RAM, depending on the content.
