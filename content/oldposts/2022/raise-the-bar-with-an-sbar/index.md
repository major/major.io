---
author: Major Hayden
date: '2022-08-02'
summary: >-
  Efficiently communicate a problem and your recommendation in record time with
  an SBAR. 📝
tags:
  - advice
  - communication
  - devops
  - engineering
  - writing
title: Raise the bar with an SBAR
---

You discovered a problem at work.
If left unchecked, the problem could affect customers and impact revenue.
You cannot ignore it.

What now?
Who do you tell?
Will they *listen?*
Better yet, will they *understand?*

I find myself in situations like these constantly.
My roles over the years involved problems that demanded discussion, thought, and solutions.
Some problems were simple but others required complicated fixes that took months or years.

Communicating with other people about complex problems remains a challenge for me, but I learned a new tool that helps me kick off these discussions and share my recommended solutions as efficiently as possible.
The [SBAR](https://en.wikipedia.org/wiki/SBAR) technique shows up frequently in medical settings but it also works well in IT.

This post covers the nuts and bolts of the SBAR format, how to use it to your advantage, and how to communicate clearly with it.

# Components

Every SBAR contains four components. Let's go through each one.

## Situation

Hook the reader with an explanation of the events happening *right now*.
Save the backstory for later and focus on the shortest possible list of current events.

Let's use a favorite example that every system administrator can relate to: a server is down.
Your situation section might look something like this:

> **Situation**
>
> Web01 stopped responding at 3PM today and disrupted web traffic to our website at example.com.
> We cannot process orders online and customers cannot browse our list of products.
> The marketing team must update the website by the end of the day with information about next week's trade show.

The situation section includes several critical pieces of information:

* What is happening *right now?*
* Who is affected by the problem *right now?*
* How does the problem affect people *right now?*

Do you see a pattern?
Do you see it *right now?*
This section demands short sentences, active language _(more on that later)_, and a focus on *right now.*
Your efforts here charge up the reader to continue into the next section which is often the longest.

## Background

Now that you won your reader's attention, start giving some backstory.
Let's continue our example above about our unresponsive server:

> **Background**
>
> Our datacenter technicians replaced the power supply on web01 last week following a power surge.
> They found a broken case fan after replacing the power supply and they replaced that as well.
> Fred called the server vendor about the failures and they warned us that we may have a damaged motherboard following the power surge.
> Jennifer ordered a replacement motherboard which arrives this Friday.
>
> The server crashed abruptly and rebooted two more times since the maintenance.
> Normally the server rebooted without any problems, but it did not come back online after today's crash.

This section adds color and detail about the events that led up to the current situation.
It answers that question that executives enjoy asking: _"How did we get here?"_

Avoid two main pitfalls here:

* Stick to facts, not opinions or your intepretation. _(That's the next section!)_
* Keep the facts pertinent and relevant.
  If the fact doesn't help directly explain the current situation at hand, leave it out.
  Toss extra details into an appendix if needed.

The reader now understands the events happening right now and they know how we got here.
Now your experience and expertise comes into play as you bring all of the data together.

## Assessment

This remains the toughest section for me with any SBAR.
You must thread the needle of tying all the facts together without making a recommendation to the reader.

Imagine the last action movie you saw where the villain has the ability to do something terrible.
After the main character explains what the villian has, how dangerous it is, and how vulnerable the good guys are, everyone looks at them and asks: _"Okay, give it to me straight: How bad is this?"_

Going back to our server down example:

> **Assessment**
>
> We have very low confidence that web01 can host our website reliably at this critical time for our company.
> The power surge likely damaged the motherboard, but the replacement does not arrive for three more days.
> While we hoped to have web02 ready for production this week, it still needs more work.

Take all the facts you have and share your thoughts on where they stand.
Readers without your experience or level of familiarity with the situation appreciate this section since it ties the first two sections together.
Clearly state the root cause of the current situation, the severity, and the impact if left unresolved.
Your goal here is to get the reader to ask the right question for the next section: _"What do we do now?"_

## Recommendation

Now it's time to plot a course forward out of the situation and back to happier times.
Make clear recommendations that include a _what_, _why_, and _how_.
Assume that every recommendation must survive cross-examination from other engineers and executives.

Our recommendations for fixing our server could include:

> **Recommendation**
>
> 1. Deploy a temporary web server at our public cloud provider to bridge the gap while web01 is awaiting a hardware replacement.
> Our deployment scripts already work in cloud instances and the our cost for the temporary instance is within our IT budget.
> 2. Finish provisioning web02 and configure high availability services so that it can run in active-active mode with web01 as soon as the replacement motherboard arrives.
> 3. Repair web01 on Friday and run burn-in tests during the week of the trade show to ensure it operates reliably under load.
> 4. Schedule a maintenance after the trade show to tie web01 and web02 together as an H/A pair and move the website traffic back from the cloud provider.
> 5. Order a spare parts package from the server vendor to have on hand for future issues with either server.

Be specific and detailed here.
Keep the following things in mind:

* Think about potential objections (time, cost, etc) and address those in the recommendation itself.
* Consider work items beyond the current situation to prevent it from happening again later.
* If you have a team working on it, consider multiple simultaneous workstreams and what you could accomplish with each.

Your reader wants to know what to do, so don't be bashful here.
You are an expert and you know the situation well.
Tell the reader what must be done, why it must be done, and how to do it (at a high level).

# Extra credit

Now that you know all the sections of an SBAR, you're ready to write one!
I learned plenty of tips along the way[^tips] and these should help you improve your SBAR skills.

[^tips]: I learned tips from making mistakes. 🤭

## Use active language

The SBAR format provides an efficient method for communicating complex problems and recommendations with other people.
Using active language keeps the readers attention and allows you to speak more directly and forcefully.

Take the following example:

> The server is down because a cart was rolling down the hallway and it hit the server after a datacenter technician forgot to set the brake.

Ugh. That's a mouthful.
How about this instead:

> A datacenter technician left a cart unattended on the ramp without setting the brake. The cart rolled down and knocked the server off the rack, taking it offline.

Active language keeps the reader's attention by keeping the subject followed by a verb.
There's no question of who did what and how that caused a problem.
Remove any [passive voice](https://en.wikipedia.org/wiki/Passive_voice) that you find and look for sentences without a subject followed by a verb.

## Use an appendix

Sometimes an assessment leads to multiple options for a solution.
Add these potential solutions to an appendix and allow readers to review those if they need more detail.
This reduces clutter in the main part of the SBAR but allows detail-oriented readers to pull out more context without bothering you.

Appendixes are great places for charts, diagrams, and command line output that reinforce your recommendations.

## Keep it collaborative

As you write the SBAR, invite others to collaborate with you.
My company uses Google Docs heavily and it allows me to bring in more contributors to improve various parts of the document.

This also helps when you're ready to present your work.
Readers can comment and ask questions right in the document.
You can add extra details or answer the questions right in the SBAR document.

# Wrapping up

The SBAR process offers you a great opportunity to improve your communication skills as an engineer, especially when you communicate with less technical people.
You can learn what motivates different people within your organization and tailor your communication so that it matches the things they care about.

These soft skills can also take your career to the next level.
Highly technical people who communicate well about complex topics are always in demand.
