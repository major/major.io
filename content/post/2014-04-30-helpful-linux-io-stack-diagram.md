---
title: Helpful Linux I/O stack diagram
author: Major Hayden
type: post
date: 2014-04-30T15:03:46+00:00
url: /2014/04/30/helpful-linux-io-stack-diagram/
dsq_thread_id:
  - 3642807487
categories:
  - Blog Posts
tags:
  - command line
  - linux
  - performance
  - sysadmin

---
During one of my regular trips to reddit, I stumbled upon an amazingly helpful Linux I/O stack diagram:

[<img src="/wp-content/uploads/2014/04/linux-io-stack-diagram_v1.0-212x300.png" alt="linux-io-stack-diagram_v1.0" width="212" height="300" class="aligncenter size-medium wp-image-4874" srcset="/wp-content/uploads/2014/04/linux-io-stack-diagram_v1.0-212x300.png 212w, /wp-content/uploads/2014/04/linux-io-stack-diagram_v1.0-723x1024.png 723w, /wp-content/uploads/2014/04/linux-io-stack-diagram_v1.0.png 1240w" sizes="(max-width: 212px) 100vw, 212px" />][1]

It's quite comprehensive and it can really help if you're digging through a bottleneck and you're not quite sure where to look. The original diagram is available in multiple formats [from Thomas Krenn's website][2].

If you combine that with this slide from [Brendan Gregg's][3] _[Linux Performance Analysis and Tools][4]_ presentation from Scale 11x, you can attack performance problems with precision:

[<img src="/wp-content/uploads/2014/04/scalelinuxperformance-130224171331-phpapp01-dragged-300x230.png" alt="scalelinuxperformance-130224171331-phpapp01 (dragged)" width="300" height="230" class="aligncenter size-medium wp-image-4875" srcset="/wp-content/uploads/2014/04/scalelinuxperformance-130224171331-phpapp01-dragged-300x230.png 300w, /wp-content/uploads/2014/04/scalelinuxperformance-130224171331-phpapp01-dragged-1024x787.png 1024w" sizes="(max-width: 300px) 100vw, 300px" />][5]

 [1]: /wp-content/uploads/2014/04/linux-io-stack-diagram_v1.0.png
 [2]: http://www.thomas-krenn.com/en/wiki/Linux_I/O_Stack_Diagram
 [3]: https://twitter.com/brendangregg
 [4]: http://www.slideshare.net/brendangregg/linux-performance-analysis-and-tools
 [5]: /wp-content/uploads/2014/04/scalelinuxperformance-130224171331-phpapp01-dragged.png
