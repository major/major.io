---
title: Simple server monitoring with xinetd
author: Major Hayden
type: post
date: 2008-12-03T00:13:10+00:00
url: /2008/12/02/simple-server-monitoring-with-xinetd/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642805445
categories:
  - Blog Posts
tags:
  - monitoring
  - xinetd

---
You can use the simple but powerful xinetd on your Linux server to monitor almost anything on the server. Since xinetd just holds open a port and waits for a connection, you can tell it to run a script and return the output directly to the network stream.

To start, you'll need a script which will return data to stdout. In this example, I'll use a very simple script like the following:

```
#!/bin/bash
echo `uptime | egrep -o 'up ([0-9]+) days' | awk '{print $2}'`
```

This script pulls the number of days that the server has been online. Make the script executable with a `chmod +x`.

Now, you'll need to choose a port on which to run the xinetd service. I normally find a service in `/etc/services` that I won't be using on the server. In this example, I'll use _isdnlog_, which runs on port 20011. Create a file called `/etc/xinetd.d/myscript` and include the following in the file:

```
service isdnlog
{
	disable	= no
	socket_type	= stream
	protocol	= tcp
	wait		= no
	user		= root
	server		= /path/to/script.sh
	server_args	= test
}
```

Depending on your xinetd version, you may need to enable your new configuration and restart xinetd:

```
chkconfig myscript on
/etc/init.d/xinetd restart
```

You can test your new script using netcat:

```
$ uptime
18:10:30 up 141 days, 19:17,  1 user,  load average: 0.65, 1.47, 1.14
$ nc localhost 20011
141
```

If you need to pass arguments to your script, just adjust the _server_args_ line in the xinetd configuration. Also, be sure that your script is set up to handle the arguments.
