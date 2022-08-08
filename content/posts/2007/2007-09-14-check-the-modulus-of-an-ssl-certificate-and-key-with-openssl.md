---
title: Check the modulus of an SSL certificate and key with openssl
author: Major Hayden
date: 2007-09-14T17:13:51+00:00
url: /2007/09/14/check-the-modulus-of-an-ssl-certificate-and-key-with-openssl/
dsq_thread_id:
  - 3644340050
tags:
  - command line
  - security
  - web

---
When you create a CSR and private key to obtain an SSL certificate, the private key has some internal data called a modulus. This is integral to the security of your SSL encryption, but for this specific post, we will focus on one specific aspect.

If your private key and certificate do not contain the same modulus, then Apache will sometimes refuse to start or it may not respond properly to SSL requests. You can check the modulus of your private key and SSL certificate with these commands:

```
# openssl rsa -noout -modulus -in server.key | openssl md5
# openssl x509 -noout -modulus -in server.crt | openssl md5
```

If the MD5 checksums match, then the certificate and key will work together. However, if they are different, then you cannot use them together. Generally, this means that you used the wrong CSR (that corresponded to some other private key) when you obtained/created your SSL certificate.
