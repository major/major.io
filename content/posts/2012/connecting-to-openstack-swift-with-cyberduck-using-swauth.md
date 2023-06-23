---
aliases:
- /2012/07/18/connecting-to-openstack-swift-with-cyberduck-using-swauth/
author: Major Hayden
date: 2012-07-18 20:21:54
dsq_thread_id:
- 3647737146
tags:
- mac
- openstack
- swauth
- swift
title: Connecting to OpenStack Swift with Cyberduck using swauth
---

Connecting to an [OpenStack Swift][1] instance that is using [swauth][2] for authentication is quite easy within [Cyberduck][3] on the Mac. Open Terminal.app and run this command:

```
defaults write ch.sudo.cyberduck cf.authentication.context /auth/v1.0
```


Keep in mind that this changes the authentication URI for **all** OpenStack swift connections made by Cyberduck. If this isn't what you want, you can easily set it back to the default by running:

```
defaults write ch.sudo.cyberduck cf.authentication.context /v1.0
```


There's more information about these settings in [Cyberduck's Swift Howto][4].

 [1]: http://docs.openstack.org/developer/swift/
 [2]: http://gholt.github.com/swauth/dev/
 [3]: http://cyberduck.ch/
 [4]: http://trac.cyberduck.ch/wiki/help/en/howto/openstack