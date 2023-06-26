---
aktt_notify_twitter:
- false
aliases:
- /2009/06/19/deleting-all-e-mail-messages-in-your-inbox-with-mutt/
author: Major Hayden
date: 2009-06-19 17:37:58
tags:
- command line
- email
- imap
- mail
- mutt
title: Deleting all e-mail messages in your inbox with mutt
---

Occasionally, I'll end up with a mailbox full of random data, alerts, or other useless things. If you have SSH access to the server, you can always clear out your mail spool, but if you connect to an IMAP server, you can use mutt to do the same thing.

First, use mutt to connect to your server remotely (via IMAP over SSL in this example):

```
mutt -f imaps://mail.yourdomain.com/
```

Once you've connected and logged in, press **SHIFT-D** (uppercase d). The status bar of mutt should show:

```
Delete messages matching:
```

Type in `~s .*` so that the line looks like:

```
Delete messages matching: ~s .*
```

When you press enter, mutt will put a **D** next to all of the messages, which marks them for deletion. Press `q` to quit, and then `y` to confirm the deletion. After a brief moment, all of those messages will be deleted and mutt will exit.

**Update:** There's an even faster way to remove all of the messages in a mailbox with mutt. Just hold shift while pressing D, ~ (tilde), and A to select everything:

```
D~A
```