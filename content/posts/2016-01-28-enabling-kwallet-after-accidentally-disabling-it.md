---
title: Enabling kwallet after accidentally disabling it
author: Major Hayden
type: post
date: 2016-01-28T16:27:44+00:00
url: /2016/01/28/enabling-kwallet-after-accidentally-disabling-it/
dsq_thread_id:
  - 4531177006
categories:
  - Blog Posts
tags:
  - fedora
  - kde
  - python
  - security

---
![cover]

Although I use GNOME 3 as my desktop environment, I prefer KDE's [kwallet][1] service to gnome-keyring for some functions. The user interface is a little easier to use and it's easier to link up to the [keyring module][2] in Python.

## Accidentally disabling kwallet

A few errant mouse clicks caused me to accidentally disable the kwalletd service earlier today and I was struggling to get it running again. The daemon is usually started by dbus and I wasn't entirely sure how to start it properly.

If I start kwalletmanager, I see the kwallet icon in the top bar. However, it's unresponsive to clicks. Starting kwalletmanager on the command line leads to lots of errors in the console:

```
kwalletmanager(20406)/kdeui (Wallet): The kwalletd service has been disabled
kwalletmanager(20406)/kdeui (Wallet): The kwalletd service has been disabled
kwalletmanager(20406)/kdeui (Wallet): The kwalletd service has been disabled
```


Manually running kwalletd in the console wasn't successful either.

## Using kcmshell

KDE provides a utility called kcmshell that allows you to start a configuration panel without running the entire KDE environment. If you disable kwallet accidentally like I did, this will bring up the configuration panel and allow you to re-enable it:

```
kcmshell4 kwalletconfig
```


You should see kwallet's configuration panel appear:

<a href="/wp-content/uploads/2016/01/kwallet-control-module-e1453998029696.png" rel="attachment wp-att-6054"><img src="/wp-content/uploads/2016/01/kwallet-control-module-e1453998029696.png" alt="KDE wallet control module for kwallet" width="700" height="513" class="aligncenter size-full wp-image-6054" /></a>

Click on **Enable the KDE wallet subsystem** and then click OK. Once the window closes, start kwalletmanager and you should be able to access your secrets in kwallet again.

_Photo Credit: [Wei][4] via [Compfight][5] [cc][6]_

 [1]: https://www.kde.org/applications/system/kwalletmanager/
 [2]: https://pypi.python.org/pypi/keyring
 [4]: https://www.flickr.com/photos/73589829@N00/14283880173/
 [5]: http://compfight.com
 [6]: https://creativecommons.org/licenses/by-nc-nd/2.0/
 [cover]: /wp-content/uploads/2016/01/14283880173_bc12e718fe_b-e1453998408758.jpg
