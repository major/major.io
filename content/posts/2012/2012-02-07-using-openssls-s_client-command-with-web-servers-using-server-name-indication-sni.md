---
title: Using OpenSSL’s s_client command with web servers using Server Name Indication (SNI)
author: Major Hayden
date: 2012-02-07T14:07:41+00:00
url: /2012/02/07/using-openssls-s_client-command-with-web-servers-using-server-name-indication-sni/
dsq_thread_id:
  - 3642716400
tags:
  - apache
  - command line
  - networking
  - security
  - ssl
  - sysadmin
  - web

---
One of the handiest tools in the OpenSSL toolbox is `s_client`. You can quickly view lots of details about the SSL certificates installed on a particular server and diagnose problems. For example, use this command to look at Google's SSL certificates:

```
openssl s_client -connect encrypted.google.com:443
```


You'll see the chain of certificates back to the original certificate authority where Google bought its certificate at the top, a copy of their SSL certificate in plain text in the middle, and a bunch of session-related information at the bottom.

This works really well when a site has one SSL certificate installed per IP address (this used to be a hard requirement). With [Server Name Indication][1] (SNI), a web server can have multiple SSL certificates installed on the same IP address. SNI-capable browsers will specify the hostname of the server they're trying to reach during the initial handshake process. This allows the web server to determine the correct SSL certificate to use for the connection.

If you try to connect to rackerhacker.com with `s_client`, you'll find that you receive the default SSL certificate installed on my server and not the one for this site:

```
$ openssl s_client -connect rackerhacker.com:443
Certificate chain
 0 s:/C=US/ST=Texas/L=San Antonio/O=MHTX Enterprises/CN=*.mhtx.net
   i:/C=US/O=SecureTrust Corporation/CN=SecureTrust CA
 1 s:/C=US/O=SecureTrust Corporation/CN=SecureTrust CA
   i:/C=US/O=Entrust.net/OU=www.entrust.net/CPS incorp. by ref. (limits liab.)/OU=(c) 1999 Entrust.net Limited/CN=Entrust.net Secure Server Certification Authority
```


Add on the `-servername` argument and `s_client` will do the additional SNI negotiation step for you:

```
$ openssl s_client -connect rackerhacker.com:443 -servername rackerhacker.com
Certificate chain
 0 s:/OU=Domain Control Validated/OU=PositiveSSL/CN=rackerhacker.com
   i:/C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=PositiveSSL CA
 1 s:/C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=PositiveSSL CA
   i:/C=US/ST=UT/L=Salt Lake City/O=The USERTRUST Network/OU=http://www.usertrust.com/CN=UTN-USERFirst-Hardware
 2 s:/C=US/ST=UT/L=Salt Lake City/O=The USERTRUST Network/OU=http://www.usertrust.com/CN=UTN-USERFirst-Hardware
   i:/C=SE/O=AddTrust AB/OU=AddTrust External TTP Network/CN=AddTrust External CA Root
 3 s:/C=SE/O=AddTrust AB/OU=AddTrust External TTP Network/CN=AddTrust External CA Root
   i:/C=SE/O=AddTrust AB/OU=AddTrust External TTP Network/CN=AddTrust External CA Root
```


You may be asking yourself this question:

> Why doesn't the web server just use the `Host:` header that my browser sends already to figure out which SSL certificate to use?

Keep in mind that the SSL negotiation must occur **prior** to sending the HTTP request through to the remote server. That means that the browser and the server have to do the certificate exchange earlier in the process and the browser wouldn't get the opportunity to specify which site it's trying to reach. SNI fixes that by allowing a `Host:` header type of exchange during the SSL negotiation process.

 [1]: http://en.wikipedia.org/wiki/Server_Name_Indication
