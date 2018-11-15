---
title: Survive the Google Reader exodus with Tiny Tiny RSS
author: Major Hayden
type: post
date: 2013-03-17T21:27:38+00:00
url: /2013/03/17/survive-the-google-reader-exodus-with-tiny-tiny-rss/
dsq_thread_id:
  - 3642807132
categories:
  - Blog Posts
tags:
  - general advice
  - google reader
  - mysql
  - php
  - security
  - ssl
  - sysadmin
  - web

---
![1]

It's no secret that [Google Reader][2] is a popular way to keep up with your RSS feeds, but it's [getting shelved later this year][3]. Most folks [suggested Feedly as a replacement][4] but I found the UI quite clunky in a browser and on Android devices.

Then someone suggested [Tiny Tiny RSS][5]. I couldn't learn more about it on the day Google Reader's shutdown was announced because the site was slammed. In a nutshell, Tiny Tiny RSS is a well-written web UI for managing feeds and a handy API for using it with mobile applications. The backend code is written in PHP and it supports MySQL and Postgres.

There's also an [Android application][6] that gives you a seven day trial once you install it. The [pro key costs $1.99][7].

The installation took me a few minutes and then I was off to the races. I'd recommend implementing SSL for accessing your installation (unless you like passing credentials in the clear) and enable keepalive connections in Apache. The UI in the application drags down a ton of javascript as it works and enabling keepalives will keep your page load times low.

If you want to get your Google Reader feeds moved over in bulk, just export them from Google Reader:

  1. Click the settings cog at the top right of Google Reader and choose Reader Settings
  2. Choose Import/Export from the menu
  3. Press Export, head over to Google Takeout and download your zip file

Unzip the file and find the .xml file. Open up a browser, access Tiny Tiny RSS and do this:

  1. Click Actions > Preferences
  2. Click the Feeds tab
  3. Click the OPML button at the bottom
  4. Import the xml file that was in the zip file from Google

From there, just [choose a method for updating feeds][8] and you should be all set!

 [1]: /wp-content/uploads/2013/03/tinytinyrss.png
 [2]: http://en.wikipedia.org/wiki/Google_Reader
 [3]: http://www.newyorker.com/online/blogs/books/2013/03/farewell-dear-reader.html
 [4]: http://news.cnet.com/8301-1023_3-57574777-93/feedly-adds-500k-new-users-on-google-decision-to-kill-reader/
 [5]: http://tt-rss.org/redmine/projects/tt-rss/wiki
 [6]: https://play.google.com/store/apps/details?id=org.fox.ttrss&hl=en
 [7]: https://play.google.com/store/apps/details?id=org.fox.ttrss.key
 [8]: http://tt-rss.org/redmine/projects/tt-rss/wiki/UpdatingFeeds
