---
title: 'Postfix: 554 Relay access denied'
author: Major Hayden
type: post
date: 2007-08-31T01:06:02+00:00
url: /2007/08/30/postfix-554-relay-access-denied/
dsq_thread_id:
  - 3642769837
categories:
  - Blog Posts
tags:
  - mail

---
Let's say you have a user who can't receive e-mail. Each time they send a message to the server, this pops up in the mail logs:

```
postfix/smtpd[23897]: NOQUEUE: reject: RCPT from remotemailserver.com[10.0.0.2]: 554 <user@domain.com>: Relay access denied; from=<user@otherdomain.com> to=<user@domain.com> proto=ESMTP helo=<remotemailserver.com>
```

This is happening because Postfix is receiving e-mail for a domain for which it doesn't expect to handle mail. Add the domains to the `mydestination` parameter in /etc/postfix/main.cf:

```
mydestination = domain.com, domain2.com, domain3.com
```

If you have a lot of domains to add, create a mydomains hash file and change the `mydestination` parameter:

```
mydestination = hash:/etc/postfix/mydomains
```

Create /etc/postfix/mydomains:

```
localhost               OK
localmailserver.com     OK
domain.com              OK
```

Then run:

```
# postmap /etc/postfix/mydomains
```

This will create the hash file (mydomains.db) within /etc/postfix. If you've just added the directive to the main.cf, run `postfix reload`. However, if the directive was already there, but you just adjusted the mydomains and ran postmap, then there is nothing left to do.
