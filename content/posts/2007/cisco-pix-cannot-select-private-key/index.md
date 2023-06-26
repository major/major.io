---
aliases:
- /2007/05/27/cisco-pix-cannot-select-private-key/
author: Major Hayden
date: 2007-05-28 02:10:13
tags:
- security
title: 'Cisco PIX: Cannot select private key'
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