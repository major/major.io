---
title: Change the escape keystrokes in screen
author: Major Hayden
date: 2010-01-07T14:11:23+00:00
url: /2010/01/07/change-the-escape-keystrokes-in-screen/
dsq_thread_id:
  - 3642805940
tags:
  - command line
  - linux
  - mac
  - screen

---
One of my favorite (and most used) applications on any Linux machine is [screen][1]. Once you fire up a screen session, you can start something and keep it running indefinitely. Even if your internet connection drops or you accidentally close your terminal window, the screen session will remain open on the remote server.

Detaching from a screen session is done by pressing CTRL-A and then d (for detach). However, when I'm on my Mac, CTRL-A and CTRL-E send my cursor to the beginning and end of lines, respectively. Once I launch screen, I lose the CTRL-A functionality because screen thinks I'm trying to send it a command.

Luckily, this can be changed in your `~/.screenrc`:

<pre lang="html">escape ^Ww</pre>

With this change, you can press CTRL-W, then press d, and you'll detach from the screen session. For all of the screen options, run `man screen` on your local machine or review the [man page online][2].

 [1]: http://www.gnu.org/software/screen/
 [2]: http://linuxmanpages.com/man1/screen.1.php
