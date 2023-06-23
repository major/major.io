---
aliases:
- /2007/06/14/php-cli-memory-limit-is-different-between-users-and-root/
author: Major Hayden
date: 2007-06-14 22:53:33
dsq_thread_id:
- 3648463080
tags:
- command line
title: PHP CLI memory limit is different between users and root
---

If you find that memory limits differ between root and other users when PHP scripts are run from the command line, there may be an issue with your php.ini or your script. To verify that it isn't your script, try this:

```
$ echo "<? var_dump(ini_get('memory_limit')); ?>" >> memtest.php
$ php -f memtest.php
string(3) "8M"
$ su -
# php -f memtest.php
string(3) "64M"
```

If you get the same two values from both users, there's probably a problem with your script. Make sure that there's no `ini_set()` functions in your script that are overriding the php.ini file.

However, if you get results like the ones above, check the permissions on /etc/php.ini:

```
# ls -al /etc/php.ini
-rw-------  1 root root 27 Jun  6 18:39 /etc/php.ini
```

As you can see, php.ini is only readable to root, which prevents PHP's command line parser from accessing your custom memory_limit directive in the php.ini. PHP's general default is 8M for a memory limit if nothing is specified anywhere else, and that's why normal users cannot get the higher memory limit that's set in your php.ini file.

Simply set the permissions on the file to 644 and you should be set to go:

```
# chmod 644 /etc/php.ini
# ls -al /etc/php.ini
-rw-r--r--  1 root root 45022 Jun  6 23:00 /etc/php.ini
```