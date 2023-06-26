---
aliases:
- /2009/12/03/disable-acceleration-for-apples-magic-mouse/
author: Major Hayden
date: 2009-12-03 13:55:41
tags:
- apple
- mac
- magic mouse
title: Disable acceleration for Apple’s Magic Mouse
---

**Edit:** After further research, I found that this fix only adjusts the speed at which your mouse moves. It doesn't do anything for the acceleration curve.

I recently picked up a [Magic Mouse][1] and discovered that I like almost all of its features. The biggest headache is the funky mouse acceleration curve that it applies by default. When you make small movements, they barely even register on the screen. When you make big movements and slow down a little mid-move, the pointer slows down much too rapidly.

A quick Google search revealed a [support discussion post][2] where users were discussing possible solutions. Someone suggested running this in the terminal:

<pre lang="html">defaults write -g com.apple.mouse.scaling -1</pre>

That improved things a little for me, but it's not perfect. If you adjust the tracking speed in System Preferences after running this command, the acceleration curve will be reset to the default.

**Update:** After some tinkering (and [further Googling][3]), I found that `` or `.1` seemed to work better for me than `-1`.

 [1]: http://www.apple.com/magicmouse/
 [2]: http://discussions.apple.com/thread.jspa?messageID=10640835
 [3]: http://reviews.cnet.com/8301-13727_7-10392736-263.html