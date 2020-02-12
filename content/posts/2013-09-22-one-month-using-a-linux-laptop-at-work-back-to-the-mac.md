---
title: 'One month using a Linux laptop at work: Back to the Mac'
author: Major Hayden
type: post
date: 2013-09-23T02:38:59+00:00
url: /2013/09/22/one-month-using-a-linux-laptop-at-work-back-to-the-mac/
dsq_thread_id:
  - 3642807386
categories:
  - Blog Posts
tags:
  - email
  - fedora
  - linux
  - mac
  - sysadmin

---
This post has been a bit delayed, but I want to follow up on the [post I wrote last month][1] about moving from OS X to Linux at work. I started out with a Lenovo Thinkpad X1 Carbon along with Fedora 19 and KDE. Although most things went really well, there were a few deal-breakers that sent me back to the Mac.

Just to give you an idea of my daily workflow, much of my day revolved around my calendar and email. As much as I don't like to have my life revolve around a calendar, that's the way it can be at times. This means I need quick access to handle and generate invitations but I also need speedy access to entire email threads and email searches. On top of all that, I review and edit many documents. The majority of the documents I handle are fairly simple but there are some very complex ones as well. Outside of those tasks, I log into remote servers via ssh/RDP, manage social connections (IM, twitter, and IRC), and surf the web.

Without further ado, here are the top three things that (regrettably) pushed me back to OS X at work:

**Email management**

Connecting to Exchange at work gives me quite a few options:

  * Thunderbird + davmail
  * Thunderbird + IMAP/POP
  * Thunderbird + Exquilla
  * Evolution + EWS
  * Evolution + IMAP/POP
  * Claws Mail + IMAP/POP

The best method I found was Thunderbird plus [Exquilla][2]. The performance was quite good and the GAL search worked decently. Thunderbird's keyboard shortcuts were intuitive and easy to begin using regularly with a few days' use. Even with the global indexer enabled, Thunderbird's overall performance was just fine on the X1.

My main gripes showed up when following large email threads on mailing lists or trying to find replies to a message I'd send previously. The [Thunderbird Conversations][3] extension helped to an extent, but it really mangled up the UI. Searching the global index was unpredictable. I knew an email was sitting in my inbox but the search function didn't return the message. Even in situations where I knew I'd received hundreds of emails from the same sender, the global indexer sometimes couldn't find any of them.

The Claws UI was too minimalistic and Evolution, although feature packed, really chewed up the CPU on the X1 and drained the battery.

**Calendar management**

After trying Thunderbird with davmail, Thunderbird with [1st setup's extension][4], and Evolution with EWS, I was horribly frustrated. My calendar was a mess and some of the applications started marking meetings I'd previously accepted as tentative. It confused the meeting organizers and even confused some of the attendees of meetings that I'd scheduled.

Inviting other coworkers to meetings led to unpredictable results. Sometimes I could see their free/busy times but most times I couldn't. Getting contacts from the GAL into the invitations sometimes worked and sometimes didn't. In situations where an emergency get-together was required, this became extremely annoying.

My last resort was to keep OWA open in Chrome all day and use it for all of my calendaring. That worked quite well but it meant flipping between Thunderbird and OWA to handle invitations. I'd considered using OWA for email as well, but it lacked the functionality I needed for GPG signing among other things.

**Microsoft Office compatibility**

LibreOffice's work on compatibility was impressive, but it still falls well short of the native Microsoft Office applications. Excel documents with pivot tables were often mangled and Word documents with any complex formatting adjustments were left unreadable. I'm not a fan of PowerPoint, but I handle those documents regularly and LibreOffice did an acceptable job.

If you don't have to worry with Office documents at your job, then you might think this is a silly requirement. However, I need quick access to review and edit these documents as I don't like these tasks to occupy my day. I like to get in, get out, and get back to what I'm good at doing.

**Summary**

All in all, I could use Linux as my daily laptop OS if I wasn't so dependent on my calendar, email, and Office documents. It would definitely be a good choice for me if I was still doing heavy development and system administration. Linux has indeed come a long way (I've said it before) and the stability is impressive. Even during heavy usage periods, I never had a crash in X and hardly ever had a screen flicker. Adding monitors via DVI and USB (DisplayPort) was extremely easy in KDE and I was able to connect to projectors almost as easily as I can in OS X.

I still have the X1 and I'm using it for other projects at home. The laptop itself is fantastic and I'm eager to see when Lenovo starts adding Haswell chips to the remainder of the Thinkpad line.

 [1]: /2013/08/26/moving-from-os-x-to-linux-day-one/
 [2]: https://exquilla.zendesk.com/home
 [3]: https://addons.mozilla.org/en-us/thunderbird/addon/gmail-conversation-view/
 [4]: http://www.1st-setup.nl/wordpress/?page_id=133
