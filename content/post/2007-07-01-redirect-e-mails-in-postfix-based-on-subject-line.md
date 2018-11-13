---
title: Redirect e-mails in postfix based on subject line
author: Major Hayden
type: post
date: 2007-07-01T16:37:31+00:00
url: /2007/07/01/redirect-e-mails-in-postfix-based-on-subject-line/
dsq_thread_id:
  - 3642768276
categories:
  - Blog Posts
tags:
  - mail

---
Depending on your situation, it may be handy to redirect e-mails that have a certain subject line before it even reaches a user's inbox. Let's say you're tired of getting e-mails that start with the word "Cialis". Just follow these steps to redirect those e-mails.

First, enable header checks in /etc/postfix/main.cf:

`header_checks = regexp:/etc/postfix/header_checks`

Then, create /etc/postfix/header_checks and add the following:

 `/^Subject: Cialis*/<br />
REDIRECT someotheruser@domain.com`

For a lot more information about header checks in postfix, review the documentation here:

  * <http://www.postfix.org/header_checks.5.html>
