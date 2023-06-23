---
aliases:
- /2010/01/21/switching-between-audible-and-visual-bells-in-screen/
author: Major Hayden
date: 2010-01-21 14:37:09
dsq_thread_id:
- 3646701431
tags:
- command line
- irc
- irssi
- screen
title: Switching between audible and visual bells in screen
---

About a year ago, I was introduced to the joys of using [irssi][1] and [screen][2] to access irc servers. Before that time, I'd usually used graphical clients like [Colloquy][3], and I always enjoyed getting [Growl][4] notifications when someone mentioned a word or string that I set up as a trigger.

Once I started using irssi in screen, I found that the visual bell in screen didn't get my attention quickly. Luckily, someone in the [#slicehost][5] channel let me know about screen's audible bell. You can flip between the visual and audible bell with **CTRL-A** and then **CTRL-G**. If you keep repeating that key combination, you'll switch back and forth between the two (with a status update at the bottom left).

You can also set up your visual bell configuration in your .screenrc via some configuration parameters:

```
vbell [on|off]
vbell_msg [message]
vbellwait sec
```


 [1]: http://www.irssi.org/
 [2]: http://www.gnu.org/software/screen/
 [3]: http://colloquy.info/
 [4]: http://growl.info/
 [5]: irc://irc.freenode.net/slicehost