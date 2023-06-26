---
aliases:
- /2009/05/26/simple-socks-proxy-using-ssh/
author: Major Hayden
date: 2009-05-26 19:29:55
tags:
- proxy
- security
- ssh
title: Simple SOCKS proxy using SSH
---

Sometimes we find ourselves in places where we don't trust the network that we're using. I've found myself in quite a few situations where I know my data is being encrypted, but I want an additional layer of protection. Luckily, that protection is built into SSH if you'd like to use it.

Create a simple SOCKS proxy with SSH by using the `-D` flag:

<pre lang="html">ssh -D 2400 username@some.host.com</pre>

That command will open up a SOCKS proxy on your workstation on port 2400. If you configure your application to use the local SOCKS proxy, any traffic using the proxy will be sent through an encrypted SSH connection to your remote server and out to the internet. Inbound traffic through the proxy is encrypted through the same connection.

You can pair that with autossh to keep your proxy connected at all times:

<pre lang="html">autossh -f -M 20000 -D 2400 username@some.host.com -N</pre>