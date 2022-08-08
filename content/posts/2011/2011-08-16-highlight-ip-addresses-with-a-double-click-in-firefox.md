---
title: Highlight IP addresses with a double click in Firefox
author: Major Hayden
date: 2011-08-16T12:46:07+00:00
url: /2011/08/16/highlight-ip-addresses-with-a-double-click-in-firefox/
dsq_thread_id:
  - 3642806607
tags:
  - firefox
  - linux
  - mac
  - windows

---
My daily work involves working with a large number of servers and one of my frustrations with Firefox is that it's not possible to select an entire IP address with a double click with the default settings. Although it works right out of the box with Safari, you have to make a configuration adjustment in Firefox to get the same behavior.

To change the setting in Firefox, open up a new Firefox tab and go to `about:config` in the browser. Paste `word_select.stop` in the search bar that appears below your tab bar and double click the `layout.word_select.stop_at_punctuation` line. It should become bold and the value on the end will flip from true to false.

Go back to another tab and [open a web page which displays an IP address][1]. Double click on any portion of the IP address and Firefox should highlight the entire address.

 [1]: http://icanhazip.com/
