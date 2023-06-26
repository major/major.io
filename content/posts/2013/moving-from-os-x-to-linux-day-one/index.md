---
aliases:
- /2013/08/26/moving-from-os-x-to-linux-day-one/
author: Major Hayden
date: 2013-08-27 03:05:46
tags:
- command line
- fedora
- kernel
- linux
- networking
- performance
- rpm
- sysadmin
- yum
title: 'Moving from OS X to Linux: Day One'
---

The thought of using Linux as a manager in a highly Windows- and Mac-centric corporate environment isn't something to be taken lightly. Integrating with Active Directory, wrangling email with Microsoft Exchange, and taming quirky Microsoft office documents can be a challenge even with a well-equipped Mac. I decided to make a change after using a Mac at Rackspace for six years.

Let's get one thing straight: I'm not a Windows or Mac basher. Windows 7 has been a solid performer for me and OS X has an amazing UI (and a vibrant community around it). I can't make any sense out of Windows 8, but I've heard some positive things about it on tablets.

My main goal for switching to Linux is to reduce clutter. I moved away from the iPhone to Android last year because the Android gave me finer-grained controls over my phone and allowed me to troubleshoot my own problems. The Mac was working well for me, but as each release passed, it seems like more things were out of my control and I was constantly notified of something that my computer wanted me to do.

[<img src="http://major.io/wp-content/uploads/2013/08/Tux-253x300.png" alt="Tux" width="253" height="300" class="alignright size-medium wp-image-4556" srcset="/wp-content/uploads/2013/08/Tux-253x300.png 253w, /wp-content/uploads/2013/08/Tux.png 265w" sizes="(max-width: 253px) 100vw, 253px" />][1]While at this year's Red Hat Summit, I saw someone using Linux on a laptop and I asked: "How do you survive on Linux at your office?" He confided that his office is extremely Windows-centric and that it was tough to overcome in the beginning. When I asked why he stuck with Linux, he smiled and responded quickly: "When I use Linux, I feel like I can do my work without being bothered. Reducing clutter has saved me a ton of time."

In an effort to free up my time at work for the important stuff, I'm moving to Linux. I'm hoping that the move is permanent, but time will tell. If you're eager to make the same change, here's the workflow I'm using:

**Hardware**

[Thinkpad X1 Carbon][2]. It has a decent screen, a fantastic keyboard, good battery life, and it's very light. Extra displays are connected with mini-DisplayPort and that allows me to use the Mac DisplayPort dongles that I find laying around all over the place. There's no ethernet adapter, but you can pick up a USB 2.0 Gigabit adapter for $25 or less.

One nice benefit is that almost every piece of hardware is recognized within Linux. The only hangup is the fingerprint reader (due to proprietary firmware). That can be fixed but I'm too lazy to go down that road at the moment.

One of my favorite parts of the Thinkpad is the mouse buttons _above_ the trackpad. As a Mac user, I sometimes find myself highlighting the wrong piece of text or rolling backwards and forwards to get the right selection. I'm able to hold the left mouse button with my left hand while using the touchpad with my right. It feels awkward at first but it's extremely quick and accurate once you get it right.

**Distribution and Desktop Environment.**

I chose Fedora 19 with KDE. Some folks prefer Kubuntu (Ubuntu's KDE release) or Linux Mint's KDE release, but I'm a bit biased towards Fedora as I enjoy RPM/yum and I'm involved in the Fedora community.

KDE makes sense for me because it's feature-rich and the Qt-based applications are well-designed. GNOME 3 has an interface that just doesn't make sense to me, but GNOME 3's new classic mode shows a lot of potential. Cinnamon is a good alternative if you really enjoy GNOME applications. XFCE is good if you're on older hardware or if you prefer something very lightweight.

**Microsoft Exchange email**

Exchange can even be a challenge on Windows, so don't expect a cakewalk in Linux. My preferred method is to use [Thunderbird][3] and [Davmail][4]. Davmail is a translation layer that handles the Exchange connectivity (via OWA/EWS) and it serves up POP, IMAP, SMTP, LDAP, and CalDav to applications on your machine. Point Davmail to your OWA server and then configure Thunderbird to talk to Davmail. One downside is that Davmail can become a bit CPU-hungry at times and may drag down a battery on a laptop.

The latest release of [Evolution][5] for GNOME has an exchange-ews connector that works relatively well with newer versions of Exchange. There are still some bugs and missing features, especially around starring/flagging emails. The performance could be better, but it seems to perform slightly better than using Davmail. Evolution's UI was too clunky for me to use and it seemed to have significant lags when fetching email.

If you're not eager to mess with a fat client, just use Outlook Web Access in your favorite browser. Beware that OWA detects Chrome on Linux and presents you with the awful "light" interface for OWA. Add a [user agent spoofing extension][6] to Chrome and masquerade as Chrome on Windows or Mac. You'll get the rich OWA interface that makes things much easier.

**Microsoft Exchange calendar**

Getting calendaring right with Exchange seems to be more difficult than email. My preferred method is to use OWA to manage calendaring. As long as you set your user agent correctly (see previous paragraph), it works flawlessly.

Fat client users should look at Evolution's calendaring capabilities. I found it to still be pretty buggy and complex recurring invitations were often botched in the interface. Coworkers reported not seeing confirmation responses for me on certain invitations while others reported receiving multiple acceptances for the same invitation.

Another option is to use Thunderbird with Davmail via CalDav. This was as buggy as Evolution and it was excruciatingly slow.

**Microsoft Office**

LibreOffice copes well with the majority of the documents I need to edit. I took some time to bring over some of the most commonly used fonts from my Mac and I picked up the Windows fonts via [fedorautils][7]. The Calligra office suite in KDE fulfills a lot of the additional needs (like a Visio and Project replacement).

However, there are those times when you need a little more from your Office applications. I have a Windows 7 VM running in VirtualBox when I need it for some Office heavy lifting. Another option is to use Office365's web interface for the common Office applications. If your organization has SharePoint, some of the licenses allow you to have SkyDrive access within your organization and that includes the web-based Office applications as well.

**RSS feeds**

Ever since Google Reader's demise, I've switched to [Tiny Tiny RSS][8] running on a cheap VM. I can access the RSS feeds via any browser or via applications on my Nexus 4.

**IM and IRC**

[Pidgin][9] has been my go-to choice for instant messaging ever since I used GAIM. I've heard good things about telepathy/empathy but the UI didn't make much sense to me. For IRC, [Konversation][10] is a clear GUI winner with [irssi][11] being my favorite in the terminal.

**Twitter**

As you probably know, I like to use Twitter, so this was critical to my workflow. I use [TweetDeck's Chrome application][12] because it uses the streaming API and gives me plenty of one-click functionality.

**Music**

iTunes was hard to live without, but [Clementine][13] filled my needs well. It has built-in internet music services that are easy to use. I'm a Digitally Imported subscriber and I was able to log in via Clementine and access the premium streams. The podcast management isn't perfect but it's certainly a decent replacement for iTunes. It can monitor certain directories for new music and automatically populate itself with a playlist based on the music it finds.

**Networking**

All of my required VPN capabilities worked right out of the box, including OpenVPN and Cisco VPN's via VPNC. I can join 802.1x-protected wireless and wired networks with ease. Every USB to ethernet adapter I've tried has worked right out of the box without any additional configuration needed. IPv6 connectivity works just fine (as expected).

**Summary**

With one day on Linux under my belt, I'm glad I made the change. I'm able to sit down with my work laptop and use it for what I want to do with it: work. Sure, there are still notification popups from time to time, but they're either notifications that I've configured intentionally or my laptop is trying to tell me something that I really need to know. So far, the switch has caused me to think about my software in a more minimalistic way. I regularly have my browser, IM client, and IRC client open - that's all. I'm hoping that less clutter and fewer applications lead to better focus and increased productivity.

 [1]: http://major.io/wp-content/uploads/2013/08/Tux.png
 [2]: http://shop.lenovo.com/us/en/laptops/thinkpad/x-series/x1-carbon/
 [3]: http://www.mozilla.org/en-US/thunderbird/
 [4]: http://davmail.sourceforge.net/download.html
 [5]: https://projects.gnome.org/evolution/
 [6]: https://chrome.google.com/webstore/detail/user-agent-switcher-for-c/djflhoibgkdhkhhcedjiklpkjnoahfmg
 [7]: http://satya164.github.io/fedorautils/
 [8]: http://tt-rss.org/redmine/projects/tt-rss/wiki
 [9]: http://www.pidgin.im/
 [10]: http://konversation.kde.org/
 [11]: http://www.irssi.org/
 [12]: https://chrome.google.com/webstore/detail/tweetdeck/hbdpomandigafcibbmofojjchbcdagbl?hl=en-US
 [13]: http://www.clementine-player.org/