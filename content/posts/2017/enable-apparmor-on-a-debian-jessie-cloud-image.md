---
aliases:
- /2017/05/24/enable-apparmor-on-a-debian-jessie-cloud-image/
author: Major Hayden
date: 2017-05-24 16:14:03
featured_image: /wp-content/uploads/2017/05/MaxPixel.freegreatpicture.com-Knights-Glove-Middle-Ages-Knight-Historically-Armor-2010659-e1495641903942.jpg
tags:
- ansible
- apparmor
- debian
- linux
- openstack
- security
title: Enable AppArmor on a Debian Jessie cloud image
---

![1]

I merged some [initial Debian support][2] into the openstack-ansible-security role and ran into an issue enabling AppArmor. The `apparmor` service failed to start and I found this output in the system journal:

```
kernel: AppArmor: AppArmor disabled by boot time parameter
```

## Digging in

That was unexpected. I was using the [Debian jessie cloud image][3] and it uses extlinux as the bootloader. The file didn't reference AppArmor at all:

```
# cat /boot/extlinux/extlinux.conf
default linux
timeout 1
label linux
kernel boot/vmlinuz-3.16.0-4-amd64
append initrd=boot/initrd.img-3.16.0-4-amd64 root=/dev/vda1 console=tty0 console=ttyS0,115200 ro quiet
```


I [learned][4] that AppArmor is **disabled by default** in Debian unless you **explicitly enable it**. In contrast, SELinux is enabled unless you turn it off. To make matters worse, Debian's cloud image doesn't have any facilities or scripts to automatically update the extlinux configuration file when new kernels are installed.

## Making a repeatable fix

My two goals here were to:

  1. Ensure AppArmor is enabled on the next boot
  2. Ensure that AppArmor remains enabled when new kernels are installed

The first step is to install grub2:

```
apt-get -y install grub2
```


During the installation, a package configuration window will appear that asks about where grub should be installed. I selected `/dev/vda` from the list and waited for apt to finish the package installation.

The next step is to edit `/etc/default/grub` and add in the AppArmor configuration. Adjust the `GRUB_CMDLINE_LINUX_DEFAULT` line to look like the one below:

```
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet apparmor=1 security=apparmor"
GRUB_CMDLINE_LINUX=""
```


Ensure that the required AppArmor packages are installed:

```
apt-get -y install apparmor apparmor-profiles apparmor-utils
```


Enable the AppArmor service upon reboot:

```
systemctl enable apparmor
```


Run `update-grub` and reboot. After the reboot, run `apparmor_status` and you should see lots of AppArmor profiles loaded:

```
# apparmor_status
apparmor module is loaded.
38 profiles are loaded.
3 profiles are in enforce mode.
   /usr/lib/chromium-browser/chromium-browser//browser_java
   /usr/lib/chromium-browser/chromium-browser//browser_openjdk
   /usr/lib/chromium-browser/chromium-browser//sanitized_helper
35 profiles are in complain mode.
   /sbin/klogd
   /sbin/syslog-ng
   /sbin/syslogd
   /usr/lib/chromium-browser/chromium-browser
   /usr/lib/chromium-browser/chromium-browser//chromium_browser_sandbox
   /usr/lib/chromium-browser/chromium-browser//lsb_release
   /usr/lib/chromium-browser/chromium-browser//xdgsettings
   /usr/lib/dovecot/anvil
   /usr/lib/dovecot/auth
   /usr/lib/dovecot/config
   /usr/lib/dovecot/deliver
   /usr/lib/dovecot/dict
   /usr/lib/dovecot/dovecot-auth
   /usr/lib/dovecot/dovecot-lda
   /usr/lib/dovecot/imap
   /usr/lib/dovecot/imap-login
   /usr/lib/dovecot/lmtp
   /usr/lib/dovecot/log
   /usr/lib/dovecot/managesieve
   /usr/lib/dovecot/managesieve-login
   /usr/lib/dovecot/pop3
   /usr/lib/dovecot/pop3-login
   /usr/lib/dovecot/ssl-params
   /usr/sbin/avahi-daemon
   /usr/sbin/dnsmasq
   /usr/sbin/dovecot
   /usr/sbin/identd
   /usr/sbin/mdnsd
   /usr/sbin/nmbd
   /usr/sbin/nscd
   /usr/sbin/smbd
   /usr/sbin/smbldap-useradd
   /usr/sbin/smbldap-useradd///etc/init.d/nscd
   /usr/{sbin/traceroute,bin/traceroute.db}
   /{usr/,}bin/ping
0 processes have profiles defined.
0 processes are in enforce mode.
0 processes are in complain mode.
0 processes are unconfined but have a profile defined.
```


## Final thoughts

I'm still unsure about why AppArmor is disabled by default. There aren't that many profiles shipped by default (38 on my freshly installed jessie system versus 417 SELinux policies in Fedora 25) and many of them affect services that wouldn't cause significant disruptions on the system.

There is a [discussion that ended last year][5] around how to automate the AppArmor enablement process when the AppArmor packages are installed. This would be a great first step to make the process easier, but it would probably make more sense to take the step of enabling it by default.

_Photo credit: [Max Pixel][6]_

 [1]: /wp-content/uploads/2017/05/MaxPixel.freegreatpicture.com-Knights-Glove-Middle-Ages-Knight-Historically-Armor-2010659-e1495641903942.jpg
 [2]: https://github.com/openstack/openstack-ansible-security/commit/4e9a8a1d6ab556628555063402dd5f491814b9db
 [3]: https://cdimage.debian.org/cdimage/openstack/
 [4]: https://wiki.debian.org/AppArmor/HowToUse#Enable_AppArmor
 [5]: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=702030
 [6]: http://maxpixel.freegreatpicture.com/Knights-Glove-Middle-Ages-Knight-Historically-Armor-2010659