---
aliases:
- /2008/06/17/why-i-use-plesk/
author: Major Hayden
date: 2008-06-17 17:00:47
tags:
- plesk
title: Why I use Plesk
---

It seems like I have a conversation like this one at least once a week:

**Them:** "Hey Major, you're a pretty nerdy guy, what server distro do you use?"

**Me:** "I use CentOS 4 right now."

**Them:** "CentOS? Why not use something more cutting edge, like Fedora or Gentoo?"

**Me:** "Well, I like those, but Plesk works really well with CentOS."

**Them:** "Seriously? You use Plesk? WHY?"

My CentOS server hosts a fair amount of domains for people I know and people I don't know. I share the box with a colleague of mine, and most of the customers are his. I'd rather not handle calls at 3AM for a user that wants to change a password or a user who wants to make a new mailbox. Plesk is a burden to work around at times, yes, but it saves me from more headaches than it creates.

Some might be saying, "well, why Plesk when there's other panels around that are better?" This question is highly subjective. Not all panels will work for all people, and that's why there's competition (although Parallels has been buying so many panels lately, they might eradicate the competition).

Here's why I like Plesk:

**Ease of use**

For the customers on the server, Plesk looks similar to their Windows XP desktop. Anyone that knows me will know that I dislike Windows and their user interfaces, but I give kudos to Plesk for giving users something that looks familiar to them. This reduces the questions that administrators receive, and it empowers the individual customer to do more for themselves.

**Good integration with enterprise operating systems**

Red Hat is a fairly solid OS platform, and Plesk works well with it. It uses RPM's and it can even be upgraded using up2date and yum (if you're so inclined). The autoinstaller is just a script that automatically downloads RPM's and executes them in groups. Although Plesk upgrades can be a little sketchy at times, having the ability to use RPM to add and remove packages can get you out of a bind in a more organized fashion.

**Extensive back-end utilities that I'm familiar with**

I work on Plesk servers daily as a [Racker][1], so performing advanced tasks with Plesk is a fairly straightforward process. While Plesk uses some mediocre daemons (courier-imap, proftpd) for some tasks and downright awful daemons for others (qmail), I can usually sort out any issues that pop up.

**Responsive and interested development team**

I've talked to Plesk developers via phone and in person several times. They are genuinely interested in writing a solid, user-friendly product, and they're open to suggestions. Of course, mistakes are made (dhparam issues, bind chroot debacles) but they do their best to get updates out. The lead developer, Andrey, is a very friendly guy with a lot of good ideas. Also, his ideas make sense - he's not trying to make Plesk into something more than it needs to be.

**If Plesk didn't exist, what would you use?**

If I didn't have the time to write my own (which I don't right now), I'd use DirectAdmin. It's extremely fast, but lacking in features. However, it's a pretty solid panel and the pricing is very reasonable. Again, it's another solid panel on CentOS/RHEL, which is a plus for me.

 [1]: http://www.rackspace.com/