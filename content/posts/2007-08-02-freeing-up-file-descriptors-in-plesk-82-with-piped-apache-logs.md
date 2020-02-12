---
title: Freeing up file descriptors in Plesk 8.2 with piped Apache logs
author: Major Hayden
type: post
date: 2007-08-03T02:39:45+00:00
url: /2007/08/02/freeing-up-file-descriptors-in-plesk-82-with-piped-apache-logs/
dsq_thread_id:
  - 3679038255
tags:
  - plesk
  - web

---
If you've used Plesk with a large amount of domains, you know what a pain running out of file descriptors can be. Web pages begin acting oddly, Horde throws wild errors, and even squirrelmail rolls over onto itself. Luckily, Plesk introduced piped Apache logs (along with lots of bugs!) in Plesk 8.2, and you can enable piped logs with the following commands:

```
# mysql -uadmin -p`cat /etc/psa/.psa.shadow` psa -e "replace into misc (param,val) values ('apache_pipelog', 'true');"
# /usr/local/psa/admin/sbin/websrvmng -v -a
```

Technically, these changes will allow Plesk to host about 900 sites, but this is still a little extreme in my opinion, even on the best hardware money can buy. If you find yourself passing the 900 mark, then you should probably follow this [SWSoft KB][1] article, adjust your FD_SETSIZE and recompile.

More information about configuring piped logs can be found on [SWSoft's site][2]. _Thanks, Jon!_

 [1]: http://kb.swsoft.com/en/260
 [2]: http://kb.swsoft.com/en/2066
