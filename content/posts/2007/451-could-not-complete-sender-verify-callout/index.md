---
aliases:
- /2007/03/29/451-could-not-complete-sender-verify-callout/
author: Major Hayden
date: 2007-03-29 14:17:06
tags:
- mail
title: 451 Could not complete sender verify callout
---

This is one of Exim's more cryptic errors:

```
Mar 29 11:22:52 114075-web1 postfix/smtp[20589]: 9E0142FC589: to=<orders@somehost.com>, relay=somehost.com[11.11.11.11], delay=147966, status=deferred (host somehost.com[11.11.11.11] said: 451 Could not complete sender verify callout (in reply to RCPT TO command))
```

When you send e-mail to an Exim server with a sender verify callout enabled, the Exim server will connect back into your server and verify that your server accepts mail for the sender's e-mail address. For example, if you send e-mail from orders@somehost.com, the Exim server will connect back into your server and do this:

```
HELO someotherhost.com
250 somehost.com
MAIL FROM: test@someotherhost.com
250 2.1.0 Ok
RCPT TO: orders@somehost.com
250 2.1.5 Ok
```

Exim will make sure that it gets a 250 success code before it will allow the e-mail to come into its server. Some situations that cause problems with this process are:

* Port 25 is blocked inbound on the sender's server
* Something else is filtering port 25 inbound on the sender's server
* The sender's server uses blacklists which delay the responses to Exim's commands