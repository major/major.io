---
title: Installing package groups with up2date
author: Major Hayden
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

```
# up2date -i "@X Window System"
```

This will tell up2date to install all of the packages that are marked within the "X Window System" package group. That would include X drivers, the X libraries/binaries, and twm (among many other packages). If you're not sure which groups are available, just pass the `--show-groups` flag and review the list:

```
# up2date --show-groups
Administration Tools
Arabic Support
Assamese Support
Authoring and Publishing
Base
Bengali Support
Brazilian Portuguese Support
British Support
Bulgarian Support
Catalan Support
Chinese Support
Compatibility Arch Development Support
Compatibility Arch Support
Core
Cyrillic Support
Czech Support
DNS Name Server
Danish Support
Development Libraries
Development Tools
Dialup Networking Support
Dutch Support
Editors
Emacs
Engineering and Scientific
Estonian Support
FTP Server
Finnish Support
French Support
GNOME
GNOME Desktop Environment
GNOME Software Development
Games and Entertainment
German Support
Graphical Internet
Graphics
Greek Support
Gujarati Support
Hebrew Support
Hindi Support
Hungarian Support
ISO8859-2 Support
ISO8859-9 Support
Icelandic Support
Italian Support
Japanese Support
KDE
KDE (K Desktop Environment)
KDE Software Development
Korean Support
Legacy Network Server
Legacy Software Development
Mail Server
Miscellaneous Included Packages
MySQL Database
Network Servers
News Server
Norwegian Support
Office/Productivity
Polish Support
Portuguese Support
PostgreSQL Database
Printing Support
Punjabi Support
Romanian Support
Ruby
Russian Support
Serbian Support
Server
Server Configuration Tools
Slovak Support
Slovenian Support
Sound and Video
Spanish Support
Swedish Support
System Tools
Tamil Support
Text-based Internet
Turkish Support
Ukrainian Support
Web Server
Welsh Support
Windows File Server
Workstation Common
X Software Development
X Window System
XEmacs
```
