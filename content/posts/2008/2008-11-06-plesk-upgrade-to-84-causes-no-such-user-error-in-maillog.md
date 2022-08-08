---
title: 'Plesk: Upgrade to 8.4 causes “no such user” error in maillog'
author: Major Hayden
date: 2008-11-06T17:04:08+00:00
url: /2008/11/06/plesk-upgrade-to-84-causes-no-such-user-error-in-maillog/
dsq_thread_id:
  - 3659092962
tags:
  - mail
  - plesk

---
If you have a Plesk server where short mail names are enabled, upgrading to Plesk 8.4 can cause some issues. Valid logins may be rejected, and they'll appear in your /usr/local/psa/var/log/maillog as "no such user". You can correct the issue by switching to long mail names (click Server -> Mail in Plesk), or you can [run a shell script][1] provided by [Parallels][2].

For further details, refer to the Plesk KB article ["Mail users cannot get or send mail after upgrade to Plesk 8.4"][3]

 [1]: http://kb.parallels.com/Attachments/4889/Attachments/mail_fix.sh
 [2]: http://parallels.com/
 [3]: http://kb.parallels.com/en/5256
