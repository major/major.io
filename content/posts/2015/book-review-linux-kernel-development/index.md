---
aliases:
- /2015/06/21/book-review-linux-kernel-development/
author: Major Hayden
date: 2015-06-21 15:26:54
dsq_thread_id:
- 3866861229
tags:
- book
- fedora
- general advice
- kernel
- linux
title: 'Book Review: Linux Kernel Development'
---

[<img src="/wp-content/uploads/2015/06/linux_kernel_development_cover-233x300.jpg" alt="Linux Kernel Development book cover" width="233" height="300" class="alignright size-medium wp-image-5676" srcset="/wp-content/uploads/2015/06/linux_kernel_development_cover-233x300.jpg 233w, /wp-content/uploads/2015/06/linux_kernel_development_cover.jpg 500w" sizes="(max-width: 233px) 100vw, 233px" />][1]I picked up a copy of [Robert Love's][2] book, [Linux Kernel Development][3], earlier this year and I've worked my way through it over the past several weeks. A few people recommended the book to me on Twitter and I'm so glad they did. This book totally changed how I look at a system running Linux.

## You must be this tall to ride this ride

I've never had formal education in computer science or software development in the past. After all, my degree was in Biology and I was on the path to becoming a phyisician when this other extremely rewarding career came into play. _(That's a whole separate blog post in itself.)_

Just to level-set: I can read C and make small patches when I spot problems. However, I've never set out and started a project in C on my own and I haven't really made any large contributions to projects written in C. However, I'm well-versed in Perl, Ruby, and Python mainly from job experience and leaning on some much more skilled colleagues.

The book recommends that you have a basic grasp of C and some knowledge around memory management and process handling. I found that I was able to fully understand about 70% of the book immediately, another 20% or so required some additional research and practice, while about 10% was mind-blowing. Obviously, that leaves me with plenty of room to grow.

Honestly, if you understand how most kernel tunables work and you know at least one language that runs on your average Linux box, you should be able to understand the majority of the material. Some sections might require some re-reading and you might need to go back and read a section when a later chapter sheds more light on the subject.

## Moving through the content

I won't go into a lot of detail around the content itself other than to say it's extremely comprehensive. After all, you wouldn't be reading a book about something as complex as the Linux kernel if you weren't ready for an onslaught of information.

The information is organized in an effective way. Initial concepts are familiar to someone who has worked in user space for quite some time. If you've dealt with oom-killer, loaded kernel modules, or written some horrible code that later needed to be optimized, you'll find the beginning of the book to be very useful. Robert draws plenty of distinctions around kernel space, user space, and how they interact. He take special care to cover SMP-safe code and how to take non-SMP-safe code and improve it.

I found a ton of value in the memory management, locking, and the I/O chapters. I didn't fully understand the blocks of C code within the text but there was a ton of value in the deep explanations of how data flows (and doesn't flow) from memory to disk and back again.

## The best part

If I had to pick one thing to entice more people to read the book, it would be the way Robert explains every concept in the book. He has a good formula that helps you understand the how, the what, **and** the why. So many books forget the _why_.

He takes the time to explain what frustrated the kernel developers that made them write a feature in the first place and then goes into detail about how they fixed it. He also talks about differences between other operating systems (like Unix, Windows, and others) and other hardware types (like ARM and Alpha). So many books leave this part out but it's often critical for understanding difficult topics. I learned this the hard way in my biology classes when I tried to memorize concepts rather than trying to understand the evolutionary or chemical reasons for why it occurs.

Robert also rounds out the book with plenty of debugging tips that allow readers to trudge through bug hunts with better chances of success. He helps open the doors to the Linux kernel community and gives tips on how to get the best interactions from the community.

## Wrap-up

This book is worth it for anyone who wants to learn more about how their Linux systems operate or who want to actually write code for the kernel. Much of the deep workings of the kernel was a mystery to me before and I really only knew how to interact with a few interfaces.

Reading this book was like watching a cover being taken off of a big machine and listening to an expert explain how it works. It's definitely worth reading.

 [1]: /wp-content/uploads/2015/06/linux_kernel_development_cover.jpg
 [2]: https://www.rlove.org/
 [3]: http://www.informit.com/store/linux-kernel-development-9780672329463