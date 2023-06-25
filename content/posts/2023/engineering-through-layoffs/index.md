---
author: Major Hayden
date: '2023-06-25'
summary: |
  Layoffs create traumatic times for many. Find ways to break through the frustration
  and pain. For those that stay, your ability to influence the business can grow. 🪴
tags:
  - advice
title: Engineering through layoffs
coverAlt: Old train tracks leading into the sea
coverCaption: |
  Photo by <a href="https://unsplash.com/@laukev?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Kévin et Laurianne Langlais</a>
  on <a href="https://unsplash.com/photos/iMRlp_Ldxus?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
---

{{< alert >}}
All comments and thoughts in this post are my own and certainly do not reflect the positions of any of my employers, past and present.
The goal of this post is to help with healing after a layoff event and organizing your thoughts around your decisions afterwards.
{{< /alert >}}

Whatever you want to call them -- layoffs, reductions in force, or downsizing -- they're terrible.

For those who leave, uncertainty can become overwhelming.
Loss of work means a loss of salary on the simplest level, but it can also mean a loss of purpose.
It can mean a loss of critical medical insurance benefits.

For those who stay, layoffs shake the foundations of trust with the employer.
I have a whole blog post on [red flags](/p/red-flags) that goes into detail on this topic, so I won't repeat it all here.

My argument in this post is that for those who stay and recommit to the mission of the business, **you have much more control over customer outcomes than you ever did before.**

# How to think about layoffs

I went through several rounds of layoffs at my last employer and my current employer just did a round.
Engineers around me often say things like:

* "How could they let him go? He was so helpful!"
* "She is critical to this project and it's our top priority. How could she leave now?"
* "He was there for 24 years and he helped everyone, even our CEO. Why would they make him go?"
* "Our quarterly results looked great. Why does anyone need to be laid off?"

The first step is to avoid **reading deeply into the decision** and avoid **making it personal**.

In my experience, some of the decisions are made based on data that you can't see at a publicly traded company.
Sometimes a company sheds employees simply because everyone in their market sector is doing it and they're looking for a temporary bump in the stock price.
And then there are those situations where a company chooses to end a product line or project.

These decisions are often made at a high level within the company and done in such a way to avoid any type of employment-related lawsuits.
That brings me to my next topic.

# Why do they let top performers go?

This frustrated me many times over the years.
As an example, there was a talented network engineer on a team who was a rising star in the company.
He could work through complex network topologies to provide a balance of performance and security based on the customer's demands.

Even better, he could explain it all to customers.
Better still, he could explain it to the customer's technical and non-technical staff.

The customer was getting closer to making the deal and this engineer was central to the deal being made.
The deal was **large**.
Everyone was preparing with implementation calls, documents, and everything else needed for the final meeting.

**The final meeting came, but the network engineer wasn't on the call.**

Salespeople, solutions architects, and other engineers were frantic.
*Did he go home sick?*
*Did we send him the wrong time on the calendar invitation?*

No, as it turns out, he was laid off at lunch and the call was scheduled for 2PM.

A choice was made to reduce engineering staff by some percentage, so the business essentially did this:

```sql
SELECT * FROM employees
WHERE job_family == "engineering"
ORDER BY RAND()
LIMIT 100
```

And they went through the list methodically until their percentage was met.

**This is why taking layoffs personally will only cause you pain.**
Avoid looking for a deeper meaning and explanation where one does not exist.

As Yoda once said:

> Fear is the path to the dark side.
> Fear leads to anger.
> Anger leads to hate.
> Hate leads to suffering.

How about the people who aren't top performers?

# Why don't companies just lay off low performers?

*(Again, try to to avoid looking for deeper meaning here, but I'll go through this question anyway.)*

I've heard this many times and I've asked it myself before:

> Why don't companies just lay off the low performers?
> After all, some of these people might be toxic to teams and it's clear they're not committed to the company mission.

It's a good argument!
If a company wants to save money by spending less on salaries and benefits, why not target the people who aren't doing the work first?
You'd reduce expenses while improving the quality of the workforce!

Long story short: **It's not that simple.**

A wise manager once told me that:

> If you're the last person to find out that your performance is inadequate, that's not your fault.
> It's your manager's fault.

Managers make mistakes.
Whether they're mistakes made on purpose or not, it often opens the company up to litigation.

For example, a manager might label an employee as a low performer due to factors outside their job performance.
Perhaps they don't look like the rest of the team, they have a different religious affiliation, or a different sexual orientation.
They might not participate in after-work functions with the team where alcohol is involved.
In some extreme situations, an employee might be labeled a low performer due to rejected romantic advances from the manager.
_(This last one seems crazy, but I've seen it happen once.)_

The problem shows up when the company tries to do a layoff like this:

```sql
SELECT * FROM employees
WHERE performance_level == "unacceptable"
ORDER BY RAND()
LIMIT 100
```

Suddenly there are people on the low performing list who don't belong there.
However, at the executive level, they have no idea about the dubious performance reviews.

**This is a fast path to wrongful termination lawsuits.**

{{< alert >}}
First off, be sure that you're ready to recommit to the company mission.
If something happened that shook your commitment to the core, take some time to truly understand how you feel about your company.
My post on [red flags](/p/red-flags) might help.
{{< /alert >}}

Let's get back on something positive.
How do we avoid taking these events personally and push through to something better?

# Use your newfound power

As an engineer, you have more control over customer outcomes after a layoff than ever before.
Confused?
I'll explain.

I've worked in engineering, management, and leadership roles in technology since 2004.
In many situations, engineers struggle to change business processes and persuade business-minded people to change their outlook on a topic.
There's another blog post on here about [persuasion engineering](/p/persuasion-engineering/) that might be worth reading.

Layoffs shake the foundations of any company, including the processes that brought the company to that point.
It's a great time to question any of these processes.
*Does the process save time?*
*Does it benefit customers?*
*Does it need to be modified?*
*Should we throw it away completely?*

I'm not suggesting that you approach all processes and business justifications with immediate contempt, but have the courage to ask questions about them.
Even long-held beliefs should be questioned.

For example, I recently had an exchange like this one:

* Me: *"What if we offered customers the capability to do X?"*
* Them: *"Well, we don't have any data to support that."*
* Me: *"This could be an opportunity to guide customers to doing X on our Y product."*
* Them: *"But we need something well defined that customers have asked for before going down that path."*
* Me: *"We've followed that data for quite some time and the uptake from customers is low. We just went through a round of layoffs -- perhaps we should take a leap here and try something new?"*

The number one fear I have as someone who stays when a layoff happens is this:
***What if we're too afraid to speak up?***
***What if we're too afraid to take a leap?***
***What if fear of being next on the layoff list prevents us from doing something amazing?***

**You can be an advocate for change.**
It's the best environment to make a change and think differently about where the company can best serve its customers.

It could end in one of two ways:

1. You change the future of the company for the better and delight your customers
2. You're on the termination list for the next layoff

On the first one, you've done something truly incredible and you will likely receive recognition for it.
You'll also feel more engaged in your work.

On the second one, if the company decides you rocked the boat too much and decides to let you go, it's for the best.
You're likely dealing with some levels of middle management who lead with fear rather than a drive to improve.
Don't take it personally and look for the next opportunity.

Personally, I'd rather go out in a blaze of glory trying to make the company a better place. 😉