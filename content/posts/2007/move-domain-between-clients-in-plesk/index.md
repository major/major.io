---
aliases:
- /2007/02/11/move-domain-between-clients-in-plesk/
author: Major Hayden
date: 2007-02-12 01:29:18
dsq_thread_id:
- 3642765215
tags:
- plesk
title: Move domain between clients in Plesk
---

Moving domains from client to client in Plesk is pretty quick from the command line. Just replace DOMAIN with the domain name you want to move and CLIENTLOGIN with the client's username:

 `/usr/local/psa/bin/domain.sh --update DOMAIN -clogin CLIENTLOGIN`