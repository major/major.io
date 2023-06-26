---
aliases:
- /2010/01/03/a-new-year-system-administrator-inspiration/
author: Major Hayden
date: 2010-01-04 02:53:53
tags:
- apache
- general advice
- kernel
- linux
- networking
title: A New Year System Administrator Inspiration
---

Happy New Year! I certainly hope it's a great one for you, your family, and your business. As the new year begins, I figured it would be a good time to sit down and answer a question that I hear very often:

_How do I become a better systems administrator?_

The best way to become a better systems administrator is to **fully understand the theory** of what's happening in your server's environment.

What do I mean by that? Learn why things aren't happening as you expected and think about all of the factors that could possibly be involved. Instead of thinking purely about cause and effect, you'll find it much easier and rewarding to consider everything inside and outside your environment before you make any changes.

This still may be a little difficult to fully understand, so he's an example. Let's say you're handling an issue where a customer can't reach a website hosted on their server. When you ask them for more details, they might give you the dreaded reply: "It's not coming up." Start by making a mental list of the problems that are easiest to check:

  * Is the web server daemon running?
  * If a database server is being used, is it running and accessible?
  * Is there a software/hardware firewall blocking port 80?
  * Is a script stuck on the server tying up resources?
  * Could there be a DNS resolution problem?
  * Is the server up?
  * Did a switch fail?
  * Is the server's hard disk out of space?
  * Can the customer reach other websites like Google or Yahoo?
  * If SELinux is involved, have the appropriate contexts been set?
  * Could the site be a target of a denial of service attack?
  * Has the server reached its connection tracking limit?

Of course, this is a relatively short list, but these are all easy to check. If you're thinking about cause and effect, you might only consider the web server daemon and some basic network issues. By considering all of the other factors that may be related, you've ensured that all of the basics are covered before you consider more complex problems.

Most systems administrators have taken an error message and tossed it in en masse into Google before. Occasionally, no results will appear for the search. If you find yourself in this situation, try to understand the individual parts of the error message. Work outward from what you know already. You should know which daemon said it, and you may have an idea of what the application was doing when the error occurred. Take time to consider what the daemon is trying to tell you within the context of what it was doing at the time.

One of the easiest ways to force yourself to be immersed into this way of thinking is to host applications for non-technical people. You'll find that many customers want things done differently, and they're all at different levels of technical aptitude. Some may find it a frustrating experience at first, but you'll think yourself later. It will force you to consider all aspects of how a server operates since you might not always know what's happening within a customer's application.

As always, if you find yourself stumbling, remember to ask your peers and colleagues. Even if they haven't seen the particular issue, they will probably be able to guide you closer to the solution you seek.