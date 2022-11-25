---
title: Move domain between clients in Plesk
author: Major Hayden
date: 2007-02-12T01:29:18+00:00
url: /2007/02/11/move-domain-between-clients-in-plesk/
dsq_thread_id:
  - 3642765215
tags:
  - plesk

---
Moving domains from client to client in Plesk is pretty quick from the command line. Just replace DOMAIN with the domain name you want to move and CLIENTLOGIN with the client's username:

 `/usr/local/psa/bin/domain.sh --update DOMAIN -clogin CLIENTLOGIN`
