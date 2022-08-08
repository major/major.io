---
title: Getting GrowlMail working with Apple Mail in Growl 1.1
author: Major Hayden
date: 2007-09-10T04:44:10+00:00
url: /2007/09/09/getting-growlmail-working-with-apple-mail-in-growl-11/
dsq_thread_id:
  - 3679025001
tags:
  - mail

---
So, this is not really related to the normal system administration topics discussed here, but it's Sunday, so I feel like something different.

I downloaded the new [Growl 1.1][1] tonight and I wanted to install GrowlMail to get mail notifications from Apple Mail. I went through the package installer, started Mail, and nothing happened. The preference pane didn't exist either. After doing a bit of [forum digging][2], I found these two commands to run in the terminal:

```
defaults write com.apple.mail EnableBundles 1
defaults write com.apple.mail BundleCompatibilityVersion 2
```

It worked like a charm and I was all set. If you haven't tried it out yet, [download the new Growl 1.1][3] and install it. There's a ton of new features, and it's been worth the wait.

 [1]: http://growl.info
 [2]: http://forums.cocoaforge.com/viewtopic.php?p=90671#90671
 [3]: http://growl.info/downloads.php
