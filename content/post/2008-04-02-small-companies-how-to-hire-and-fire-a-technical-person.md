---
title: 'Small Companies: How to hire and fire a technical person'
author: Major Hayden
type: post
date: 2008-04-02T18:00:06+00:00
url: /2008/04/02/small-companies-how-to-hire-and-fire-a-technical-person/
dsq_thread_id:
  - 3642772500
tags:
  - general advice

---
**DISCLAIMER:** Okay, technical folks - I'm doing this as a favor to the general community of people that aren't very technical, but they need to know some tips for ridding themselves of a technical person that is harming their business. If you look at it this way, there's a 50/50 chance that this article might get you hired instead of fired.

No one has every really asked me "hey, if I want to fire my technical guy and get a new one, how do I do it?" So, how can I answer this question with any authority? Simple. I used to run my own company doing technical work for homes and businesses, I was hired and fired by people (much more hiring than firing), and I've learned a lot from being "the tech guy". Also, from working at Rackspace, and a previous job, I've seen many situations in which a company lets their technical person go without any plan in place. You never realize how valuable your IT staff are until they're not in the office, and your e-mail server falls apart.

**Firing your technician**

I'll start with how to fire your current technical person. It should go without saying, but be sure that you're firing this person for a substantial and legal reason. If you're firing this person for something trivial or petty, **stop right here and re-evaluate**. But, if this is the kind of person that ignores your phone calls, takes down services to increase job security, or prints pornography on the office laserjet, then it's time for them to go.

First, create a plan. How much does this technical person know about the company that could be detrimental if they were fired abruptly? You'll need to consider things like their access to your buildings, computers, corporate credit cards, cars, and colocated/dedicated servers. Take an inventory of the access that they have, and also how they access these items. For example, if they have multiple user accounts on your computer network, then make sure that all of those accounts are accounted for. If you have secret passwords with any of your service providers, be sure those are documented as well.

If you don't know some of these items, but your technical person does, you might want to get this information from them in a careful manner. I'd recommend against going in and saying something like "we need to inventory all of our user accounts before you're canned". You need to find a plausible excuse for you to have a list of this information, and it needs to be something that the technical person won't argue with. Some good ones I've heard are PCI, SOX or SAS/70 compliance. Let your employee know that compliance with these standards requires that you keep all of the access to all of these services in a safe place.

By the time you reach this stage, you really should have a new technician in mind. Interview them after work, or at night time so that the current technical person doesn't become suspicious. I'll talk more about how to find a new technical person a little later.

At this point, if you can trust your technical person, you should have a proper list of their entry points into your infrastructure. It's more likely that you don't trust this person at this point since you're firing them after all. Some might argue with me here, I'd recommend bringing in some other technical person that you undoubtedly trust. The reason for this is that your technical person may have given you a partial list, or they may have left "backdoors" so that they can access your infrastructure after they leave. A trusted tech can review your company for any possible issues and can give you a heads up if they find any red flags. Of course, if your current technical person has set up traps to know when someone logs in, then you may have blown your cover entirely. I would certainly hope that your situation wouldn't end this badly.

Now that you have a complete list of everything to which your former tech had access, you have an idea of what will be involved in changing everything over. Most people like to fire employees on Fridays to reduce the chance of violence or uncomfortable moments, so here's my recommendation. If anything financial needs to be taken care of, get it done late on Thursday or early on Friday. Then, on Friday, set a time with your current technical person to have a short meeting. Coordinate this time with your trusted technical person so they can begin changing passwords on accounts which the current tech has access to. Change the most sensitive passwords first, like the passwords on database servers. Also, change the root passwords as a high priority, but make sure you eventually change them all since you can be bitten by sudo or SSH keys.

When your current technical person exits the meeting, you're covered. If the meeting goes well, and the current technical person is amicable, then you're going to be covered since their access is revoked. If the meeting goes badly, your still covered in case they try to do something nasty. Their access to your network and corporate infrastructure should be eliminated or minimized before they can do anything destructive.

**Hiring your technician**

Luckily, hiring a new technical person is a bit easier than firing one. However, if you do a bad job on the hiring, you'll be referring to the beginning of this article fairly soon.

The best way to find a new technical person is via recommendations from another person. They've probably had interactions with the tech, and they can give you an idea of their technical prowess and social skills (yes, these are important). If you can't find any techs through recommendations, you can always check big job sites like Monster, LinkedIn, or Dice. **Whichever route you choose, be sure to meet the technician in person.** Don't hire someone based on the initials after their name, their previous job experience, or how they sound over the phone. Your technical person is like a central pillar in your organization, and this needs to be a responsible, sensible, and practical person.

Once you've found one or more technicians that you'd like to hire, you need to test them just a little. I'd recommend contacting them late in the evening (8-10PM) or early/late on the weekend. See how receptive and cordial they are at these times, because when something explodes later, you'll probably be calling them after business hours. You don't want to pick up the phone at 4AM on Saturday when your Exchange server dies only to hear your tech tell you that he'll be in on Monday to fix it for you, and that it can wait until then. When you talk to the technician on the phone, ask them to do something that forces them to go use the computer. For example, send them an e-mail for something reasonable that they need to respond to. Or, tell them that you discovered some neat product or service, and you want to know if they could start working at your company and maintain that product or service. If they respond quickly and they don't give you the vibe that you've just inconvenienced them horribly, then that's a good sign that you've found a worthy technician.

It's up to you when you bring them on at your company. Some people might want to hold off until the current technician is out of the way, but some might want to bring the technician in a little early to help with the cleanup of the last technician. Either way is good in my opinion. However, I would recommend against having both of them employed at your company simultaneously. If your old technician is upset about something, that could rub off on the new guy, and you may be returning to the top part of this article sooner rather than later.

Also, don't expect the new technician to be knee-deep in your problems immediately. They will need some time to figure out your network, review your vital services, and get an idea how everything works together. If you have the giant list your previous tech made, be sure to furnish it to the new technician so they have an idea of where to go to fix a certain problem.

I certainly hope this article helps! If you have any questions, drop me a comment and I'll be happy to give additional recommendations.
