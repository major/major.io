---
aliases:
- /2015/06/04/upatre-and-icanhazip/
author: Major Hayden
date: 2015-06-05 02:01:19
tags:
- icanhazip
- security
title: Upatre and icanhazip
---

[<img src="/wp-content/uploads/2015/06/cant_have_nice_things-300x225.jpg" alt="This is why we can&#039;t have nice things" width="300" height="225" class="alignright size-medium wp-image-5619" srcset="/wp-content/uploads/2015/06/cant_have_nice_things-300x225.jpg 300w, /wp-content/uploads/2015/06/cant_have_nice_things.jpg 490w" sizes="(max-width: 300px) 100vw, 300px" />][1]I recently updated the [icanhazip FAQ][2] about the resurgence of the [Upatre][3] malware and how it's abusing icanhazip.com. The abuse reports keep coming into the ISP's where I host the site and it's becoming a challenge to defend each one.

From what I've read, Upatre is a piece of malware that has been around in one form or another since 2013. Somewhere along the way, it began making calls to icanhazip.com to determine the public-facing IP address of the machines that it infects. I'm sure this was done by the malware authors to figure out which kinds of targets they hit. If they know the external IP address, they can easily figure out how valuable the target may be.

The information security community has been really helpful and I've received emails from several people with ways to identify the malicious requests and deny them. The malware changes over time and the most recent updates mimic the requests made by very recent versions of Firefox on Windows. Separating those requests out from the legitimate ones is extremely difficult.

I'd like to explore some ways to provide sanitized log data from icanhazip to certain security organizations so they can find trends and help more people stomp out this highly annoying piece of malware (among others).

If you have any feedback on how this might be done, let me know. Also, if you think it's a horrible idea, let me know as well.

 [1]: /wp-content/uploads/2015/06/cant_have_nice_things.jpg
 [2]: /icanhazip-com-faq/
 [3]: http://www.trendmicro.com/vinfo/us/threat-encyclopedia/malware/upatre