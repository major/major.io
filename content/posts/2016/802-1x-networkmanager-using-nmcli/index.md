---
aliases:
- /2016/05/03/802-1x-networkmanager-using-nmcli/
author: Major Hayden
date: 2016-05-03 19:23:24
tags:
- networking
- security
title: 802.1x with NetworkManager using nmcli
---

Authenticating to a wired or wireless network using 802.1x is simple using NetworkManager's GUI client. However, this gets challenging on headless servers without a graphical interface. The `nmcli` command isn't able to store credentials in a keyring and this causes problems when you try to configure an interfaces with 802.1x authentication.

If you aren't familiar with 802.1x, there is some [light reading][1] and [heavier reading][2] available on the topic.

Start by setting some basic configurations on the interface using the `nmcli` editor shell:

```
# nmcli con edit CONNECTION_NAME
nmcli> set ipv4.method auto
nmcli> set 802-1x.eap peap
nmcli> set 802-1x.identity USERNAME
nmcli> set 802-1x.phase2-auth mschapv2
nmcli> save
nmcli> quit
```


Be sure to set the `802-1x.eap` and `802-1x.phase2-auth` to the appropriate values for your network. You might have noticed that the password isn't specified here. That's because NetworkManager has no access to a keyring where it can store the password. That comes next.

Create a new file called `/etc/NetworkManager/system-connections/CONNECTION_NAME` to hold your password. If your connection name has spaces in it, be sure to maintain those spaces in the filename. Add the following to that file:

```ini
[connection]
id=CONNECTION_NAME

[802-1x]
password=YOUR_8021X_PASSWORD
```


Save the file and close it. Restart NetworkManager to pick up the changes:

```
systemctl restart NetworkManager
```


You may need to bring the interface down and up to test the new changes:

```
nmcli con down CONNECTION_NAME
nmcli con up CONNECTION_NAME
```


Once the network settles down, the authentication should complete within a few seconds in most cases. Be sure to check your system journal or other NetworkManager logs for more details if the interface doesn't work properly.

 [1]: https://en.wikipedia.org/wiki/IEEE_802.1X
 [2]: https://www.sans.org/reading-room/whitepapers/authentication/implementing-ieee-8021x-wired-networks-34520