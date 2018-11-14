---
title: Tweetdeck’s Chrome notifications stopped working
author: Major Hayden
type: post
date: 2015-05-08T13:55:55+00:00
url: /2015/05/08/tweetdecks-chrome-notifications-stopped-working/
dsq_thread_id:
  - 3747288500
categories:
  - Blog Posts
tags:
  - chrome
  - fedora
  - linux
  - twitter

---
[<img src="/wp-content/uploads/2015/05/Tweetdeck-Logo.png" alt="Tweetdeck logo" width="256" height="256" class="alignright size-full wp-image-5552" srcset="/wp-content/uploads/2015/05/Tweetdeck-Logo.png 256w, /wp-content/uploads/2015/05/Tweetdeck-Logo-150x150.png 150w" sizes="(max-width: 256px) 100vw, 256px" />][1]With the last few weeks, I noticed that Tweetdeck's notifications weren't showing up in Chrome any longer. I double-checked all of the Tweetdeck settings and notifications were indeed enabled. However, I found that Tweetdeck wasn't allowed to send notifications when I checked in my Chrome settings.

### Check your settings

To check these for yourself, hop into [Chrome's content settings][2]. Scroll down to **Notifications** and click **Manage Exceptions**. In my case, _https://tweetdeck.twitter.com_ was missing from the list entirely.

From here, you have two options: enable notifications for all sites (not ideal) or add an exception.

### The big hammer approach

To enable notifications for all sites (good for testing, not ideal in the long term), click **Allow all sites to show notifications** in the **Notifications** session.

### The right way

To enable notifications just for Tweetdeck, you may be able to add a new exception right there in the Chrome settings interface. Many users are reporting that newer versions of Chrome don't allow for that. In that case, your fix involves editing your Chrome configuration on the command line.

Chrome preferences are in different locations depending on your OS:

  * Windows: C:\Users\<username>\AppData\Local\Google\Chrome\User Data\
  * Mac: ~/Library/Application Support/Google/Chrome/
  * Linux: ~/.config/google-chrome/

**BEFORE EDITING ANYTHING,** be sure you've quit Chrome and ensured that nothing Chrome-related is running in the background. Seriously. Don't skip this step.

I'm on Linux, so I'll open up `.config/google-chrome/Default/Preferences` in vim and make some edits. You're looking for some lines that look like this:

```json
"https://tweetdeck.twitter.com:443,https://tweetdeck.twitter.com:443": {
   "last_used": {
      "notifications": 1431092689.014171
   }
},
```


Replace those lines with this:

```json
"https://tweetdeck.twitter.com,*": {
   "last_used": {
      "notifications": 1414673538.301078
   },
   "notifications": 1
},
"https://tweetdeck.twitter.com:443,https://tweetdeck.twitter.com:443": {
   "last_used": {
      "notifications": 1431094902.014302
   }
},
```


Save the file and start up Chrome once more. Head on over to [Tweetdeck][3] and you should now see the familiar Chrome toast notifications for Twitter updates!

 [1]: /wp-content/uploads/2015/05/Tweetdeck-Logo.png
 [2]: chrome://settings/content
 [3]: https://tweetdeck.twitter.com/
