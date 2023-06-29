---
aliases:
- /2013/11/13/one-year-in-information-security/
author: Major Hayden
date: 2013-11-13 15:15:12
tags:
- general advice
- information security
- security
title: One year in information security
---

Going to the dark side.  Those were my first thoughts about taking an information security role one year ago.  One year later, the situation seems much brighter than I expected.

This role has taught me more about how our business operates, how we set priorities, and how to respond to a setback.  I've been fortunate enough to meet some extremely intelligent people along the way.  Some of them frighten me with their descriptions of past experiences or their adversaries.  Other people spin a different tale about mature, consistent information security programs that deliver value to the business.

I was asked by a coworker last week to talk about three things I've learned over the past year as I transitioned from the world of managing Linux servers, wrangling software deployments, and writing python to a heavy focus on information security at a macro level.  This post is a response to that request.

Without further ado, here are the three biggest lessons I've learned over the past year:

**Double down on what motivates people**

It's easy to focus on the critics when you work in a corporate security department.  They wrestle with you on anything that causes any changes in their day-to-day work.  My immediate reaction was an angry one: "Why don't they _get it_?"  In most cases, they did get it; but the demands placed on them to complete a task or launch a product was the top priority.  It didn't take long before I was frustrated.

Luckily, I found a copy of [_Switch_][1] on a bookshelf and took it home to read it.  One of the big takeaways from the book is to look for your partners in the business when you're focused on the critics.  Find the people who are motivated to take security seriously and take them out to lunch.  Learn about their background and their previous experiences.  Discover why security is a priority for them and why it motivates them to change.  Once you find out what motivates them, double down on that motivation when you spot a critic.  It won't work every time (you certainly can't please everyone), but it has paid dividends for me.

Keep in mind that what motivates one person might not motivate the next person.  You may find someone who embraces security because they've worked through a serious breach in the past.  Retelling that story to another person might not have the same impact, but it may lead to a higher-level discussion around the value of the change you're trying to drive.

If you work in an environment with highly technical people, always remember to talk about the "why" behind the change.  In most of my communication, I generally start with the "why" or "what's broken" first.  Get them to agree that something is broken and you can lead them to your desired solution.  That initial agreement builds trust and it allows you to revert back to a common ground in case the conversation goes astray. A former manager taught me this method and it works extremely well.

I prefer to talk about things you should do rather than the things you shouldn't, but there are two critical things I have to mention.  Don't spread fear, uncertainty and doubt (FUD).  Also, certifications don't make you an expert.  When people feel that you're constantly throwing out doomsday scenarios or you're grandstanding with alphabet soup after your name, they'll become desensitized to your message.  The difficulty involved with changing their minds is then ratcheted up another level.

**Evade analysis paralysis by painting with broad strokes**

It's easy to sweat the small stuff in information security.  If you don't believe me, just look at your average vulnerability scan report.  Once you filter out all of the false positives and irrelevant vulnerabilities, you're left with a final few items that are worth an additional review.  Scan reports of multiple systems (or subnets) can get out of hand quickly.  Sure, those vulnerabilities should be fixed, but think about how you can take a bigger picture approach to the problem.

Another favorite book of mine is [_The Phoenix Project_][2].  It's an adaptation of _The Goal_ that is specific to IT workers.  The main character is suddenly promoted after his superiors are relieved and he is overwhelmed with tons of IT problems big and small.  After a good dose of firefighting and tactical work, he discovers that the problems plaguing his department are very broad.  Change management, documentation, and resource contention were completely out of control.  He comes to terms with the problems and realizes that he won't succeed unless he steps back and looks at the big picture.  There's also an amazing CISO character in the book and he goes through the same transformation.

Instead of focusing on the small battles, focus on the war.  Look for ways to drive consistency first.  If nobody has set the bar for security within your organization, set it.  Start out with something simple and partner with your supporters in the business to gain buy-in.  Setting a standard does something interesting to humans: we don't want anything we maintain to be called "substandard."

Find ways to weave your standards in with the business in helpful ways.  Write scripts.  Do demos.  Figure out which configuration management software they use and try to build your standards into the existing frameworks.  Talk to them on their turf and in their terms.  When they hear you speaking their language and integrating with their tools, they will be much more eager to collaborate with you.  That's a great time to deliver your message and weave security into the fabric of their project.

Building consistency will take time depending on the maturity of the organization.  As it builds, raise the bar with the help of your supporters.  Do it gradually and closely monitor the effects.  Businesses constantly do this with software development cycles and uptime improvements.  Implementing security is no different.

**Drive self-reliance by making them part of the process**

One of my peers said it best: "Everyone is part of the security team.  We all play a part."  Getting people to feel that they're responsible for security isn't easy, but you can make an impact by explaining the "why" behind your changes, partnering with standards, and keeping an open door policy.

Security teams need to maintain a feedback loop with the business.  I feel like I say this constantly: "We won't have a security team if we never launch a product."  There's always going to be a situation where something launches with vulnerabilities (whether known or unknown) and the business accepts the risk.  Don't dwell on that; you're sweating the small stuff.  Instead, think about helping the business avoid that risk in the future.  Should we develop a standard?  Is our testing process rigorous enough?  Do we need more detailed training for developers or engineers?

That feedback loop must include open and frank discussions about failures without a rush to blame.  My favorite example of this thought process is a post from [John Allspaw][3] titled [_Learning from Failure at Etsy_][4].  A business can drive accountability without needing to place blame.  If you've ever gone through a [fishbone diagram][5] or you've answered the [Five Why's][6], you know what I'm talking about.  Trace it back to the original failure and you'll most often find a process or a technology problem and not a people problem.

If an IT team can't be honest with a security team because they fear punishment or shaming, then they won't share the real problems.  This could be disastrous for a security team since they're operating with only a portion of the real story.  The opposite is also true: security teams must feel comfortable sharing their failures.  Healthy feedback loops like these build trust and engagement.  That leads to more process improvements and fewer failures.  If there's anything I've learned about security teams, it's that we don't want to fail.

**Conclusion**

This post might read a bit more pedantic than I intended, but I hope you find it useful.  Much of it applies to more than just information security.  Think about where you work in your company and which groups you find yourself at odds with daily.  Learn what motivates your supporters, paint with broad strokes, and make everyone part of the process.

You might find more in common with them than you ever expected.

 [1]: http://heathbrothers.com/books/switch/
 [2]: http://itrevolution.com/books/phoenix-project-devops-book/
 [3]: https://twitter.com/allspaw
 [4]: http://www.kitchensoap.com/2013/09/30/learning-from-failure-at-etsy/
 [5]: http://en.wikipedia.org/wiki/Ishikawa_diagram
 [6]: http://en.wikipedia.org/wiki/5_Whys