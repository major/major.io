---
aliases:
- /2014/03/18/show-originating-ip-address-in-apple-mail/
author: Major Hayden
date: 2014-03-18 14:20:13
tags:
- apple
- email
- mail
- security
title: Show originating IP address in Apple Mail
---

I've received some very sophisticated phishing emails lately and I was showing some of them to my coworkers. One of my coworkers noticed that my Apple Mail client displays the X-Originating-IP header for all of the emails I receive.

You can enter that IP into a whois search and get a better idea of who sent you the message without diving into the headers. If someone that regularly exchanges email with me suddenly has an originating IP in another country that would be unusual for them to travel to, I can approach the message with more caution.

Enabling this feature in Mail is a quick process:

  1. Click on the **Mail** menu, then **Preferences**
  2. Go to the **Viewing** tab
  3. Click the drop down menu next to **Show header detail** and choose **Custom**
  4. Click the **plus (+)** and type `X-Originating-IP`
  5. Click **OK** and close the **Preferences** window

This should work in Apple Mail from OS X 10.6 through 10.9. You can also search your email for messages from certain IP addresses. Just start typing `X-Originating-IP: 123.234...` into the search field and watch the results appear.