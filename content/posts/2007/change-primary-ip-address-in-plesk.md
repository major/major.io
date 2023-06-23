---
aliases:
- /2007/02/28/change-primary-ip-address-in-plesk/
author: Major Hayden
date: 2007-02-28 15:36:19
dsq_thread_id:
- 3650618373
tags:
- plesk
title: Change Primary IP Address in Plesk
---

If you need to change to a different primary IP in Plesk, here's the easiest way:

In Plesk 7 there is no concept of the Primary IP address for the server. From the Control panels point of view all IP addresses are equal. The only difference between the main IP address and aliases is that the main IP address can not be deleted from the control panel.

To change the main IP address you need to first remove this address from all IP pools. Then stop Plesk and manually change the IP address on the server from the backend as root. Then start Plesk again and restore the list of IP addresses through SERVER -> IP Aliasing and click on Re-read button.