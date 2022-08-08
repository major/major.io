---
title: Adjust max_execution_time for Horde in Plesk
author: Major Hayden
date: 2007-03-23T13:15:41+00:00
url: /2007/03/23/adjust-max_execution_time-for-horde-in-plesk/
dsq_thread_id:
  - 3644292541
tags:
  - mail
  - plesk
  - web

---
Often times, the wonderful webmail application known as Horde will spin out of control and cause unnecessary resource usage and often cause defunct Apache processes to appear. You may wonder how this can happen, especially if you set the max\_execution\_time variable in php.ini. Well, the Horde developers took it upon themselves to overwrite your settings in their own configuration file in `/usr/share/psa-horde/config/conf.xml`:

```xml
<configinteger name="max_exec_time" desc="If we need to perform a long operation, what should we set max_execution_time to (in seconds)? 0 means no limit; however, a value of 0 will cause a warning if you are running in safe mode. See http://www.php.net/manual/function.set-time-limit.php for more information.">0</configinteger>
```

It's set to forever by default in Horde. However, if you do turn on safe_mode, Horde will have some problems setting its time limit variable. You can change the zero to something more reasonable, such as 30 or 60 by editing the conf.xml and reloading Apache.
