---
title: 'Cisco PIX: Cannot select private key'
author: Major Hayden
type: post
date: 2007-05-28T02:10:13+00:00
url: /2007/05/27/cisco-pix-cannot-select-private-key/
dsq_thread_id:
  - 3642767617
tags:
  - security

---
If you receive the following error, your PIX does not have a key set up for use with SSH:

```
Type help or '?' for a list of available commands.
pix>
Cannot select private key
```

Regenerating the key can be done by executing the following:

```
conf t
ca zeroize rsa
ca generate rsa key 1024
ca save all
write mem
reload
```
