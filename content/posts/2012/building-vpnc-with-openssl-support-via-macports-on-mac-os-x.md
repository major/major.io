---
aliases:
- /2012/07/31/building-vpnc-with-openssl-support-via-macports-on-mac-os-x/
author: Major Hayden
date: 2012-08-01 04:16:09
dsq_thread_id:
- 3642807054
tags:
- command line
- mac
- networking
- security
title: Building vpnc with openssl support via MacPorts on Mac OS X
---

If you install [vpnc][1] via [MacPorts][2] on OS X, you'll find that you have no openssl support after it's built:

```
$ sudo port install vpnc
--->  Computing dependencies for vpnc
--->  Cleaning vpnc
--->  Scanning binaries for linking errors: 100.0%
--->  No broken files found.
$ sudo vpnc
vpnc was built without openssl: Can't do hybrid or cert mode.
```

This will cause some problems if you're trying to use VPN with a Cisco VPN concentrator which uses SSL VPN technology. The fix is an easy one. You'll find a variant within the portfile itself:

```
$ sudo port edit --editor cat vpnc | tail -7
variant             hybrid_cert description "Enable the support for hybrid and cert modes in vpnc" {
    depends_lib-append port:openssl
    build.args-append  "OPENSSL_GPL_VIOLATION=-DOPENSSL_GPL_VIOLATION OPENSSLLIBS=-lcrypto"
}
livecheck.type  regex
livecheck.url   ${homepage}
livecheck.regex "${name}-(\\d+(?:\\.\\d+)*)${extract.suffix}"
```

Simply specify that you want the **hybrid_cert** variant on the command line when you install vpnc and you should be all set:

```
$ sudo port install vpnc +hybrid_cert
--->  Computing dependencies for vpnc
--->  Deactivating vpnc @0.5.3_0
--->  Cleaning vpnc
--->  Activating vpnc @0.5.3_0+hybrid_cert
--->  Cleaning vpnc
--->  Scanning binaries for linking errors: 100.0%
--->  No broken files found.
$ sudo vpnc
unknown host `<gateway>'
</gateway>
```

 [1]: http://www.unix-ag.uni-kl.de/~massar/vpnc/
 [2]: http://www.macports.org/