---
aliases:
- /2014/12/05/send-weechat-notifications-via-pushover/
author: Major Hayden
date: 2014-12-05 16:11:13
tags:
- fedora
- irc
title: Send weechat notifications via Pushover
---

IRC is my main communication mechanism and I've gradually moved from graphical clients, to [irssi][1] and then to [weechat][2]. Text-based IRC removes quite a few distractions for me and it allows me to get access to my IRC communications from anything that can act as an ssh client.

I wanted a better way to get notifications when people send me messages and I'm away from my desk. [Pushover][3] is a great service that will take notification data via an API and blast it out to various devices. Once you configure your account, just install the mobile application on your device and you're ready to go.

Connecting weechat to Pushover is quite easy thanks to the [pushover.pl][4] script. Go into your main weechat console (usually by pressing META/ALT/OPTION-1 on your keyboard) and install it:

```
/script install pushover.pl
```


There are quite a few variables to configure. You can get a list of them by typing:

```
/set plugins.var.perl.push*
```


You'll need two pieces of information to configure the plugin:

  * **User key**: The user key is displayed on your main account page when you login at Pushover.
  * **Application key**: Click on _Register an Application_ towards the bottom or [use this direct link][5].

Now you're ready to configure the plugin:

```
/set plugins.var.perl.pushover.token [YOUR PUSHOVER APPLICATION TOKEN]
/set plugins.var.perl.pushover.user [YOUR USER KEY]
/set plugins.var.perl.pushover.enabled on
```


You can test it out quickly by using [Freenode's web chat][6] to send yourself a private message from another account.

 [1]: http://irssi.org/
 [2]: https://weechat.org/
 [3]: https://pushover.net/
 [4]: http://weechat.org/scripts/source/pushover.pl.html/
 [5]: https://pushover.net/apps/build
 [6]: https://webchat.freenode.net/