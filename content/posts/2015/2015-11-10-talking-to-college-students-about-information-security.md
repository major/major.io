---
title: Talking to college students about information security
author: Major Hayden
date: 2015-11-10T14:50:52+00:00
url: /2015/11/10/talking-to-college-students-about-information-security/
dsq_thread_id:
  - 4306420686
tags:
  - general advice
  - information security
  - presentation
  - security

---
![1]

I was recently asked to talk to [Computer Information Systems][2] students at the [University of the Incarnate Word][3] here in San Antonio about information security in the business world. The students are learning plenty of the technical parts of information security and the complexity that comes from dealing with complicated computer networks. As we all know, it's the non-technical things that are often the most important in those tough situations.

My talk, "Five lessons I learned about information security", lasted for about 30 minutes and then I took plenty of technical and non-technical questions from the students. I've embedded the slides below and I'll go through the lessons within the post here.

## Lesson 1: Information security requires lots of communication and relationships

Most of what information security professionals do involves talking about security. There are exceptions to this, however. For example, if your role is highly technical in nature and you're expected to monitor a network or disassemble malware, then you might be spending the majority of your time in front of a screen doing highly technical work.

For the rest of us, we spend a fair amount of time talking about what needs to be secured, why it needs to be secured, and the best way to do it. Information security professionals shouldn't be alone in this work, though. They must find ways to get the business bought in and involved.

I talked about three general buckets of mindsets that the students might find in an average organization:

> "Security is mission critical for us and it's how we maintain our customers' trust."

These are your **allies** in the business and they must be "read into" what's happening in the business. Share intelligence with them regularly and highlight their accomplishments to your leadership **as well as theirs**.

> "Security is really important, but we have lots of features to release. We will get to it."

These people often see security as a bolt-on, value added product feature. Share methods of building in security from the start and **make it easier** for them to build secure products. Also, this is a great opportunity to create **technical standards** as opposed to policies (more on that later).

> "I opened this weird file from someone I didn't know and now my computer is acting funny."

There's no way to sugar-coat this one: this group is your **biggest risk**. Take steps to prevent them from making mistakes in the first place and regularly send them high-level security communications. Your goal here is to send them information that is easy to read and keeps security **front of mind** for them without inundating them with details.

## Lesson 2: Spend the majority of your time and money on detection and response capabilities

This is something that my coworker Aaron and I talk about in our presentation called ["The New Normal"][4]. Make it easier to detect an intruder and respond to the intrusion. Don't allow them to quietly sneak through your network undetected. Force them to be a bull in a china shop. If they cross a network segment, make sure there's an alert for that. Ensure that they have to make a bunch of noise if they wander around in your network.

When something is detected, you need to do two things well: respond to the incident and communicate with the rest of the organization about it.

The response portion requires you to have plenty of information available when it's time to assess a situation. Ensure that logs and alerts are funneled into centralized systems that can aggregate and report on the events in real time (or close to real time). Take that information and understand where the intruders are, what data is at risk, and how severe the situation really is.

From there, find a way to alert the rest of the organization. The United States Department of Defense uses [DEFCON][5] for this. They can communicate the severity of a situation very quickly to thousands of people by using a simple number designation. That number tells everyone what to do, no matter where they are. Everyone has an idea of the gravity of the situation without needing to know a ton of details.

This is also a good opportunity to share limited intelligence with your allies in the business. They may be able to go into battle with you and get additional information that will help the incident response process.

## Lesson 3: People, process, and technology must be in sync

Everything revolves around this principle. If your processes and technology are great, but your people never follow the process and work around the technology, you have a problem. Great technology and smart people without process is also a dangerous mix. Just like a three-legged stool, all three legs must be strong to keep it stable. The same goes for any business.

When an incident happens, don't talk about people, what could have been done, or vendors. Why? Because no matter how delicate you are, you will eventually "call the baby ugly". Calling the baby ugly means that you insult someone's work or character without intending to, and then that person withdraws from the process or approaches the situation defensively. That won't lead to a good outcome and will usually create plenty of animosity.

Assume the worst will happen again and make your processes and technologies better over time. This is an iterative process, so keep in mind that a thousand baby steps will always deliver more value than one giant step.

## Lesson 4: Set standards, not policies

Policies are inevitable. We get them from our compliance programs, our governments, and other companies. They're required, but they're horribly annoying. Have you ever read through [ISO 27002][6] or [NIST 800-53][7]? If you have, you know what I mean. Don't get me started on [PCI-DSS 3.1][8], either.

What's my point? Policies are dry. They're long. They're often chock-full of requirements that are really difficult to translate into technical changes. There's no better way to clear out a room of technical people than to say "Let's talk about PCI-DSS." (Seriously, try this at least once. It's amazing.)

You need to use the right kind of psychology to get the results you want. Threatening someone with policy is like getting someone to go in for a root canal. They know they need it, but they know how much it will hurt.

Instead, create technical standards that are actionable and valuable. If you know you need to meet PCI-DSS and ISO 27002 for your business, create a technical standard that allows someone in the business to design systems that meet both compliance programs. Make it actionable and then show them the results of their labor when they're done.

Also, give them a method for checking their systems against the standard in an automated way. Nobody wants [The Spanish Inquisition][9] showing up at the end of a project to say "Hey, you missed something!". They'll be able to check their progress along the way.

## Lesson 5: Don't take security incidents personally

This one is still a challenge for me. Security incidents will happen. They certainly won't be fun. However, when the smoke clears, look at the positive aspects of the incident. These situations highlight two critical things:

  1. Room for improvement (and perhaps additional spending)
  2. What attackers really want from your business

Take the time to understand what type of attacker you just dealt with and what their target really was. If a casual script kiddie found a weakness, you obviously need to invest in more security basics, like network segmentation and hardening standards. If a nation state or some other type of determined attacker found a weakness, you need to understand what they were trying to get. This can be challenging and sometimes third parties can help give an unbiased view.

## Required reading

There are three really helpful books I mentioned in the presentation:

  * [Switch: How to Change Things When Change is Hard][10]
  * [Winning With People][11]
  * [The Phoenix Project][12]

These three books help you figure out how to make change, build relationships, and work around challenges in IT.

## Final thoughts

If you haven't been to your local university to meet the next generation of professionals, please take the time to do so. There's nothing more exciting than talking with people who have plenty of knowledge and are ready to embrace something new. In addition, they yearn to talk to people who have more experience in the real world.

Thanks to John Champion from UIW for asking me to do a talk! It was a fun experience and I can't wait to do the next one.

<iframe src='https://www.slideshare.net/slideshow/embed_code/54910235' width='425' height='348' allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>

 [1]: /wp-content/uploads/2015/11/UIW_CIMG7805-e1447167032674.jpg
 [2]: http://www.uiw.edu/cis/
 [3]: http://www.uiw.edu/
 [4]: http://blog.rackspace.com/rackspacesolve-atlanta-session-recap-the-new-normal/
 [5]: https://en.wikipedia.org/wiki/DEFCON
 [6]: https://en.wikipedia.org/wiki/ISO/IEC_27002
 [7]: https://en.wikipedia.org/wiki/NIST_Special_Publication_800-53
 [8]: https://www.pcisecuritystandards.org/security_standards/documents.php
 [9]: https://en.wikipedia.org/wiki/The_Spanish_Inquisition_(Monty_Python)
 [10]: http://heathbrothers.com/books/switch/
 [11]: http://www.johnmaxwell.com/store/products/Winning-With-People-%5BPaperback%5D.html
 [12]: http://itrevolution.com/books/phoenix-project-devops-book/
