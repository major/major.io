---
aliases:
- /2007/06/14/send-plesk-e-mail-to-devnull-or-blackhole/
author: Major Hayden
date: 2007-06-14 22:42:22
tags:
- mail
- plesk
title: Send Plesk e-mail to /dev/null or blackhole
---

Should you find yourself needing to send e-mail destined for a certain account to a blackhole or to /dev/null, you'll find very little information from Google. The actual solution is not terribly intuitive, and not well documented:

  * Click **Domains**
  * Click the domain you want to modify
  * Click **Mail**

**If the account hasn't been created**, click "Add New Mail Name" and create the account as usual. Then simply **uncheck the mailbox** option near the bottom. This will create a mail account, but any inbound e-mail for the user is thrown out.

**If the e-mail account has already been created**, but you want to blackhole any future e-mails, just click the **Mailbox** icon and uncheck the **Mailbox** checkbox on the next page. Click **OK** and any future e-mails are thrown out.