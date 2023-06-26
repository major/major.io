---
aliases:
- /2007/06/06/replace-urchin-license-key-serial-number/
author: Major Hayden
date: 2007-06-07 04:47:52
tags:
- web
title: Replace Urchin license key / serial number
---

If something horrible happened to your Urchin license key or you need to replace it with something else, just run this command to change the key:

```
cd /usr/local/urchin/util
./uconf-driver action=set_parameter recnum=1 ct_serial=[NEW SERIAL] uconf-driver action=set_parameter recnum=1 ct_license=0
```

For some reason, this blows up on some Urchin versions. If it doesn't work, then the command will actually remove your license entirely. Don't worry! You can log into Urchin's web interface and put in the new key without a problem.