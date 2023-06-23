---
aliases:
- /2007/11/07/openssl-tricks/
author: Major Hayden
date: 2007-11-07 18:26:24
dsq_thread_id:
- 3679014592
tags:
- command line
- security
- ssl
title: OpenSSL Tricks
---

**Create a strong CSR and private key**
  
`openssl req -new -nodes -newkey rsa:2048 -out server.crt -keyout server.key`

**Parsing out the data within a certificate**
  
`openssl asn1parse -in server.crt`

**Checking a certificate/key modulus to see if they correspond**
  
`openssl rsa -in server.key -modulus -noout | openssl md5<br />
openssl x509 -in server.crt -modulus -noout | openssl md5`

**Convert a key from PEM -> DER**
  
`openssl rsa -inform PEM -in key.pem -outform DER -out keyout.der`

**Convert a key from DER -> PEM**
  
`openssl rsa -inform DER -in key.der -outform PEM -out keyout.pem`

**Remove the password from an encrypted private key**
  
`openssl rsa -in server.key -out server-nopass.key`

**Reviewing a detailed SSL connection**
  
`openssl s_client -connect 10.0.0.1:443`