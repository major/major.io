---
aliases:
- /2007/05/31/arrow-keys-in-iterm-not-working-in-vivim/
author: Major Hayden
date: 2007-06-01 03:28:58
tags:
- command line
title: Arrow keys in iTerm not working in vi/vim
---

I found myself pretty darned frustrated when my arrow keys didn't work in iTerm in vi/vim or other ncurses-based applications. However, give this a shot in an iTerm if you find yourself in the same predicament:

`export TERM=linux`

Then open something in vi/vim or run an ncurses application. It should let your arrow keys work normally now. To make the setting stick, just do this:

`echo "TERM=linux" >> ~/.profile`