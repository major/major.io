---
title: Reset the Urchin admin password
author: Major Hayden
type: post
date: 2007-08-09T00:50:45+00:00
url: /2007/08/08/reset-the-urchin-admin-password/
dsq_thread_id:
  - 3679035181
tags:
  - command line
  - web

---
Should you find yourself in the situation where you've forgotten the Urchin admin password, don't worry. It's easily reset with the following command:

```
cd util
./uconf-driver action=set_parameter  table=user name="(admin)"  ct_password=urchin
```

This will set the password to 'urchin', and then you can log into Urchin's web interface and change it to a secure password. The credit for this fix goes to [Urchin's site][1].

 [1]: http://www.google.com/support/urchin45/bin/answer.py?answer=28531&topic=7392
