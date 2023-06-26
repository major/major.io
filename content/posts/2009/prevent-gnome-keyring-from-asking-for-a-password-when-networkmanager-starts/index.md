---
aliases:
- /2009/02/26/prevent-gnome-keyring-from-asking-for-a-password-when-networkmanager-starts/
author: Major Hayden
date: 2009-02-27 00:21:21
tags:
- annoyances
- gnome-keyring
- networkmanager
title: Prevent gnome-keyring from asking for a password when NetworkManager starts
---

I recently tossed Ubuntu 8.10 on my Mac Mini at home to use it as a home theater PC (with [Boxee][1]). When I connected to my wireless network via NetworkManager, I entered my WPA2 passphrase, and then I was prompted to enter a password for gnome-keyring. I went back to the couch, SSH'ed in, and continued configuring it remotely. When it rebooted, it never came back online.

Once I switched the TV back over to the Mini, I saw that gnome-keyring had popped up and it was asking for my password. I entered it, and the Mini joined the wireless network. Each time I rebooted, I had to go through this procedure (which is annoying to do with a HTPC that is across the room). I found a [pretty fancy solution][2], but it looked a little complicated for my setup.

Here's how I did it in a simpler way in Ubuntu 8.10:

  * Click **Applications** > **Accessories** > **Passwords and Encryption Keys**
  * Click **Edit** > **Preferences**
  * Click your keyring name (usually _default_)
  * Click **Change Unlock Password**
  * Enter your current password in the top box, but leave the bottom two boxes blank
  * Click **OK**
  * Click **Use unsafe storage** when you are prompted
  * Click **Close**

If you reboot your machine, it should not ask for a password for your keyring any longer. This allowed my system to log into my wireless network automatically.

**WHOA THERE:** Since the only password being stored on the device is my WPA2 password, I'm not concerned about the security of the keyring. If you're doing this on a laptop or desktop that other people use, I would highly recommend not following these steps. All of your passwords and keys will be stored unencrypted.

 [1]: http://boxee.tv/
 [2]: http://ubuntu-tutorials.com/2007/07/12/automatically-unlocking-the-default-gnome-keyring-pam-keyring/