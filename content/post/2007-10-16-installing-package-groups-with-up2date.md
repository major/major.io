---
title: Installing package groups with up2date
author: Major Hayden
type: post
date: 2007-10-17T01:14:53+00:00
url: /2007/10/16/installing-package-groups-with-up2date/
dsq_thread_id:
  - 3679016591
tags:
  - command line
  - red hat

---
A few days ago, I began to install a group of packages with up2date, and the person next to me was surprised that up2date even had this functionality. I use it regularly, but I realized that many users might not be familiar with it.

You can install package groups using an at-sign (@) in front of the group name:

`# up2date -i "@X Window System"`

This will tell up2date to install all of the packages that are marked within the "X Window System" package group. That would include X drivers, the X libraries/binaries, and twm (among many other packages). If you're not sure which groups are available, just pass the `--show-groups` flag and review the list:

`# up2date --show-groups<br />
Administration Tools<br />
Arabic Support<br />
Assamese Support<br />
Authoring and Publishing<br />
Base<br />
Bengali Support<br />
Brazilian Portuguese Support<br />
British Support<br />
Bulgarian Support<br />
Catalan Support<br />
Chinese Support<br />
Compatibility Arch Development Support<br />
Compatibility Arch Support<br />
Core<br />
Cyrillic Support<br />
Czech Support<br />
DNS Name Server<br />
Danish Support<br />
Development Libraries<br />
Development Tools<br />
Dialup Networking Support<br />
Dutch Support<br />
Editors<br />
Emacs<br />
Engineering and Scientific<br />
Estonian Support<br />
FTP Server<br />
Finnish Support<br />
French Support<br />
GNOME<br />
GNOME Desktop Environment<br />
GNOME Software Development<br />
Games and Entertainment<br />
German Support<br />
Graphical Internet<br />
Graphics<br />
Greek Support<br />
Gujarati Support<br />
Hebrew Support<br />
Hindi Support<br />
Hungarian Support<br />
ISO8859-2 Support<br />
ISO8859-9 Support<br />
Icelandic Support<br />
Italian Support<br />
Japanese Support<br />
KDE<br />
KDE (K Desktop Environment)<br />
KDE Software Development<br />
Korean Support<br />
Legacy Network Server<br />
Legacy Software Development<br />
Mail Server<br />
Miscellaneous Included Packages<br />
MySQL Database<br />
Network Servers<br />
News Server<br />
Norwegian Support<br />
Office/Productivity<br />
Polish Support<br />
Portuguese Support<br />
PostgreSQL Database<br />
Printing Support<br />
Punjabi Support<br />
Romanian Support<br />
Ruby<br />
Russian Support<br />
Serbian Support<br />
Server<br />
Server Configuration Tools<br />
Slovak Support<br />
Slovenian Support<br />
Sound and Video<br />
Spanish Support<br />
Swedish Support<br />
System Tools<br />
Tamil Support<br />
Text-based Internet<br />
Turkish Support<br />
Ukrainian Support<br />
Web Server<br />
Welsh Support<br />
Windows File Server<br />
Workstation Common<br />
X Software Development<br />
X Window System<br />
XEmacs`
