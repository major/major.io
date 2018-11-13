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

`aterm*loginShell:true<br />
aterm*transparent:true<br />
aterm*shading:40<br />
aterm*background:Black<br />
aterm*foreground:White<br />
aterm*scrollBar:true<br />
aterm*scrollBar_right:true<br />
aterm*transpscrollbar:true<br />
aterm*saveLines:32767<br />
aterm*font:*-*-fixed-medium-r-normal--*-110-*-*-*-*-iso8859-1<br />
aterm*boldFont:*-*-fixed-bold-r-normal--*-*-110-*-*-*-*-iso8859-1`

Then load up the changes and start aterm:

`$ xrdb -load .Xdefaults<br />
$ aterm`

Of course, if you like rxvt better for your Unicode needs, just use this configuration:

`rxvt*loginShell:true<br />
rxvt*transparent:true<br />
rxvt*shading:40<br />
rxvt*background:Black<br />
rxvt*foreground:White<br />
rxvt*scrollBar:true<br />
rxvt*scrollBar_right:true<br />
rxvt*transpscrollbar:true<br />
rxvt*saveLines:32767<br />
rxvt*font:*-*-fixed-medium-r-normal--*-110-*-*-*-*-iso8859-1<br />
rxvt*boldFont:*-*-fixed-bold-r-normal--*-*-110-*-*-*-*-iso8859-1`
