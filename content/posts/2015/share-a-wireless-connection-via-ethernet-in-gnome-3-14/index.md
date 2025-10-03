---
aliases:
- /2015/03/29/share-a-wireless-connection-via-ethernet-in-gnome-3-14/
author: Major Hayden
date: 2015-03-30 02:31:19
tags:
- fedora
- gnome
- linux
- networking
- networkmanager
title: Share a wireless connection via ethernet in GNOME 3.14
---

There are some situations where you want to do the opposite of creating a wireless hotspot and you want to share a wireless connection to an ethernet connection. For example, if you're at a hotel that offers only WiFi internet access, you could share that connection to an ethernet switch and plug in more devices. Also, you could get online with your wireless connection and create a small NAT network to test a network device without mangling your home network.

<!--more-->

Doing this in older versions of GNOME and NetworkManager [was fairly easy][1]. Newer versions can be a bit more challenging. To get started, I generally like to name my ethernet connections with something I can remember. In this example, I have a USB ethernet adapter that I want to use for sharing a wireless connection. Opening the Network panel in GNOME 3 gives me this:

[<img src="/wp-content/uploads/2015/03/Network_010.png" alt="Network control panel GNOME" width="792" height="543" class="aligncenter size-full wp-image-5443" srcset="/wp-content/uploads/2015/03/Network_010.png 792w, /wp-content/uploads/2015/03/Network_010-300x206.png 300w" sizes="(max-width: 792px) 100vw, 792px" />][2]

Click the cog wheel at the bottom right and then choose the **Identity** tab on the next window. Use a name for the interface that is easy to remember. I chose **Home USB Ethernet** for mine:

[<img src="/wp-content/uploads/2015/03/Wired_011.png" alt="Identity networkmanager panel" width="682" height="481" class="aligncenter size-full wp-image-5445" srcset="/wp-content/uploads/2015/03/Wired_011.png 682w, /wp-content/uploads/2015/03/Wired_011-300x212.png 300w" sizes="(max-width: 682px) 100vw, 682px" />][3]

Press **Apply** and then go to a terminal. Type `nm-connection-editor` and you should get a window like this:

[<img src="/wp-content/uploads/2015/03/Network-Connections_012.png" alt="Network connectionc" width="413" height="336" class="aligncenter size-full wp-image-5447" srcset="/wp-content/uploads/2015/03/Network-Connections_012.png 413w, /wp-content/uploads/2015/03/Network-Connections_012-300x244.png 300w" sizes="(max-width: 413px) 100vw, 413px" />][4]

We can add a shared network connection by pressing the **Add** button. Do the following afterwards:

  * Choose **Ethernet** from the list and press **Create&#8230;**
  * click **IPv4 Settings**
  * Choose **Shared to other computers** in the **Method** drop-down menu
  * Enter **Share via ethernet** as the **Connection name** at the top (or choose a name you prefer)

When that's all done, you can close the **Network Connections** menu we opened via the terminal. Now open the Network control panel once more. It should have two profiles for your ethernet connection now (mine is a USB ethernet device):

[<img src="/wp-content/uploads/2015/03/Network_013.png" alt="Share via ethernet" width="792" height="543" class="aligncenter size-full wp-image-5448" srcset="/wp-content/uploads/2015/03/Network_013.png 792w, /wp-content/uploads/2015/03/Network_013-300x206.png 300w" sizes="(max-width: 792px) 100vw, 792px" />][5]

If it's not already selected, just click on the **Share via ethernet** text. NetworkManager will automatically configure NAT, DHCP and firewall rules for you. When you're ready to go back to normal ethernet operation and you want to stop sharing, simply click on the other profile (mine is called **Home USB Ethernet**). NetworkManager will put the ethernet device back into the original way you had it configured (default is DHCP with automatic IPv6 via SLAAC).

 [1]: http://askubuntu.com/questions/3063/share-wireless-connection-with-wired-ethernet-port
 [2]: /wp-content/uploads/2015/03/Network_010.png
 [3]: /wp-content/uploads/2015/03/Wired_011.png
 [4]: /wp-content/uploads/2015/03/Network-Connections_012.png
 [5]: /wp-content/uploads/2015/03/Network_013.png