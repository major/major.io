---
aliases:
- /2007/07/18/importing-existing-keys-and-certificates-into-java-keystore-files/
author: Major Hayden
date: 2007-07-18 15:05:37
tags:
- command line
- web
title: Importing existing keys and certificates into java keystore files
---

Making Java keystores at the same time as you create a CSR and key is pretty easy, but if you have a pre-made private key that you want to throw into a keystore, it can be difficult. However, follow these steps and you'll ber done quickly!

Save the new certificate to server.crt and the new key to server.key. If intermediate certificates are necessary, then place all of the certificates into a file called cacert.crt. Now, you will have to make a PKCS #12 file:

```
openssl pkcs12 -export -inkey server.key -in server.crt \
    -name tomcat-domain.com -certfile cacert.crt -out domain.com.p12
```

To perform the rest of the work, you will need a copy of the [KeyTool GUI][1]. In the GUI, make a new keystore in JKS format. Import the PKCS #12 key pair, and save the keystore as a JKS. Upload the keystore to the server and then configure the keystore within Tomcat/JBoss.

 [1]: /wp-content/ktg.tgz