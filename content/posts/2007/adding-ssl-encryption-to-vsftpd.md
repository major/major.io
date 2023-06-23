---
aliases:
- /2007/11/26/adding-ssl-encryption-to-vsftpd/
author: Major Hayden
date: 2007-11-26 18:21:54
dsq_thread_id:
- 3642773545
tags:
- ftp
- security
- ssl
- vsftpd
title: Adding SSL encryption to vsftpd
---

There may be some situations where you want to encrypt FTP traffic with SSL certificates rather than using SFTP with SSH. Using vsftpd with SSL encryption is quite easy, and here's how it's done:

First, you'll need to [make a new self-signed SSL certificate][1] (if you don't have a key and certificate available already):

<pre lang="html">openssl req -new -newkey rsa:1024 -days 365 -nodes -x509 -keyout server.key -out server.crt</pre>

Once you have the key and certificate made, you'll need to concatenate them into a PEM file:

<pre lang="html"># cat server.key > /etc/vsftpd/server.pem
# cat server.crt >> /etc/vsftpd/server.pem</pre>

Now, simply adjust the vsftpd configuration file to enable SSL encryption:

<pre lang="html">ssl_enable=YES
force_local_data_ssl=NO
force_local_logins_ssl=NO
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=YES
rsa_cert_file=/etc/vsftpd/server.pem</pre>

Once that's complete, restart vsftpd and you will be able to connect to your FTP server using SSL/TLS encryption.

Further Reading:

[Manpage of vsftpd.conf][2]

 [1]: http://rackerhacker.com/2007/08/02/generate-self-signed-certificate-and-key-in-one-line/
 [2]: http://vsftpd.beasts.org/vsftpd_conf.html