---
title: Attractive aterm/rxvt .Xdefaults configuration
author: Major Hayden
type: post
date: 2007-11-04T18:04:27+00:00
url: /2007/11/04/attractive-atermrxvt-xdefaults-configuration/
dsq_thread_id:
  - 3642773765
tags:
  - command line

---
I've struggled at times to get a decent-looking terminal on my desktop, and I believe I've found a good one. Toss this into your ~/.Xdefaults:

```
aterm*loginShell:true
aterm*transparent:true
aterm*shading:40
aterm*background:Black
aterm*foreground:White
aterm*scrollBar:true
aterm*scrollBar_right:true
aterm*transpscrollbar:true
aterm*saveLines:32767
aterm*font:*-*-fixed-medium-r-normal--*-110-*-*-*-*-iso8859-1
aterm*boldFont:*-*-fixed-bold-r-normal--*-*-110-*-*-*-*-iso8859-1
```

Then load up the changes and start aterm:

```
$ xrdb -load .Xdefaults
$ aterm
```

Of course, if you like rxvt better for your Unicode needs, just use this configuration:

```
rxvt*loginShell:true
rxvt*transparent:true
rxvt*shading:40
rxvt*background:Black
rxvt*foreground:White
rxvt*scrollBar:true
rxvt*scrollBar_right:true
rxvt*transpscrollbar:true
rxvt*saveLines:32767
rxvt*font:*-*-fixed-medium-r-normal--*-110-*-*-*-*-iso8859-1
rxvt*boldFont:*-*-fixed-bold-r-normal--*-*-110-*-*-*-*-iso8859-1
```
