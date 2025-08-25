---
author: Major Hayden
date: '2025-08-24'
summary: |
  Developing software with a critcal date comes with its own set of challenges.
tags: 
  - software development
  - general advice
title: Date driven development
coverAlt: Small plants growing on a sandy surface
coverCaption: |
  Photo by <a href="https://unsplash.com/@wildandbeyondbyvivek?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Vivek Doshi</a> on <a href="https://unsplash.com/photos/shallow-focus-photo-of-black-and-white-butterfly-PNXnfta-6-4?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>   
---

Scrum, kanban, and waterfall seem familiar to most of us who work in software development, but date driven development is a complicated beast.
These are situations where something *must be completed* by a certain date that cannot be moved.

For some teams, this could be a product launch at a big company event.
An executive might need to present something to investors or analysts.
The team might need to have something ready for multiple other teams to use in their own work.

Although these situations can be stressful, it's one of those great opportunities where everyone has a chance to shine!
This post covers some techniques and strategies that you can use (at any level) to help your team reach the finish line.

# What goes on the truck?

A talented executive once took me under their wing and explained how to inspire a team to deliver results with a difficult deadline.
He would always ask, **"What goes on the truck?"**

Imagine a truck delivering your product to the big event.
There are a lots of different outcomes, but I'll boil them down to these three:

1. **The truck arrives on time with everything needed to be successful.**
   We all want this outcome, but it's not always possible.
   This should be your team's main goal and focus.
2. **The truck arrives on time with all of the required items, but some extras are missing.**
   Most of the teams I've worked with have landed here.
   Everything that the customer needs is on the truck, but some of the nice-to-haves are missing.
   Some of these items could be a "fast follow" that arrive after the event.
3. **The truck doesn't arrive.**
   You don't want this.

I once went to a fast food restaurant to order a burger and fries.
After sitting down with my drink, I waited for my food and it felt like I waited for a long time.
Someone came over and said:

> "Here's your burger, but the fries are running behind. We have a new fry cook and she's still learning. I'll have your fries over as soon as they're done."

What happened there?
I received the most important item (the burger), but not the extras (the fries).
That was fine since I came to the restaurant for a burger anyway and the fries were just a nice-to-have.
The fries were on the way, but it didn't interrupt the enjoyment of eating the burger.
The fries came along shortly and I was happy.

You can do the same thing with your product:

1. Deliver the base functionality that provides value for your customer.
2. Ship as many extras as you can.
   Identify the extras that deliver the most value for the least amount of effort.
   Work on those first.
3. Be willing to drop an extra or say "no" to something that could jeopardize the delivery of the base product.

All of this works a lot better if you communicate often about the extras, the value they provide, and the development effort required.
That's the next section!

# Clustered, candid communication

Everyone on the team and everyone who the team depends on must communicate effectively -- **and often.**
One of the biggest downfalls for any team under stress is a lack of communication.
This causes a mismatch in expectations within the group.

Here are a few simple things you can do to improve your team's communication:

1. **Talk about all deadlines often.**
   This keeps everyone on the team in the loop about important dates, especially those they might not be aware of.
   For example, development teams might not know when quality engineering teams need final builds to test.
   Product managers need early builds to share with pilot customers and sales teams.
2. **Cluster your communication.**
   Interruptions throw a wrench into a team's productivity.
   Cluster communications to a certain time of day or a certain day of the week.
   Every meeting should have a detailed agenda and clear outcomes.
   Each attendee must know what is expected of them at each meeting.
3. **Prioritize blockers.**
   If someone on the team is blocked, they need to communicate that immediately.
   Treat these problems with the highest priority and identify what you need to resolve the issue.
   Blockers are extremely demotivating and can cause issues to fall through the cracks.
4. **If you see something, say something.**
   Encourage everyone to ask questions and raise their concerns.
   I've had good experiences with an "around-the-horn" approach at the end of a meeting where the organizer calls out attendees one by one to to see how they're feeling.

Don't forget about communication outside the team!

For outbound communication, find ways to share meaningful status updates with other groups and leaders.
This can head off unnecessary interruptions by allowing people to quickly scan a status update.

Assign an point person to handle inbound communications from other teams and rotate that role often (weekly or bi-weekly).
This person can triage issues and raise concerns with the team when necessary without distrupting the team's focus.

# Set the ground rules

This one is often forgotten.
It's important to specify what is negotiable and what isn't as you start the project.

For example, during the early days of the project, teams might be allowed to merge code without full reviews or complete test coverage.
As times goes on, the team might tighten the rules, requiring more strict reviews and increased test coverage.
Teams might also forego performance optimizations during the early stages so that the base functionality gets done quickly.

Some good ground rule strategies include:

1. **Get agreement before starting.**
   Set some milestones and the requirements at each step.
   Be sure that each team member knows what is expected of them whether they're proposing a change or reviewing that change before a merge.
2. **Set build versus buy requirements.**
   It's often much easier to add modules or libraries written by other people to speed up the development of a project.
   Some of these are simple, such as HTTP libraries or logging frameworks.
   However, if a team is going to adopt something significant, such as a database or a UI framework, set some ground rules about evaluating those options.
3. **Identify who is responsible for what.**
   A [RACI matrix](https://en.wikipedia.org/wiki/Responsibility_assignment_matrix) is extremely helpful here.
   These simple charts identify everyone's role in a project, or for a piece of a project.
   Setting this up early avoids turf battles or situations where someone feels like they might be stepping on someone else's toes.
   It also identifies the right people for a potential escalation or decision.

Speaking of escalation, let's get to the last section!

# Escalate early and effectively

Most date driven development projects have a lot of visibility, especially with leaders.
It's just as critical for leaders to manage the people on the project as it for those people to manage their own leaders.

The last thing any VP wants to hear is that a project is in trouble because the team needed something trivial to complete it.
These upward communications are tricky.
Every company has their own protocols and culture, and this sometimes is specific to certain parts of a company.
However, in my experience, there are some universal things that work well:

1. **Escalate early.**
   Do not wait.
   Seriously.
   If there's a blocker that might prevent the team from delivering, let your leaders know about it.
   It's much better to escalate several silly things early than it is to escalate one critical thing late.
2. **Give a little context.**
   Explain exactly what is needed and any costs involved.
   Be sure to include what will happen if the issue is or is not resolved.
   Although this might require a little explanation of the background, keep it brief and focus on the aspects your leaders care the most about.
3. **Prove your assessment.**
   A good friend of mine said "lead with the outcome you want."
   Once an executive knows the context, they're looking for your expert guidance on what they should do.
   Empower them to make the right decision by sharing your assessment of the best course of action along with some alternatives and the disadvantages of each.
4. **Set a deadline.**
   Your leaders have tons of decisions to make with varying timelines and priorities.
   There's a big difference between "we need this by the end of the day" and "we need this by the end of the month."

The [SBAR](/p/raise-the-bar-with-an-sbar/) document gives you a great way to structure your communication in concise way that leaders can quickly understand.
It gives them an understanding of what you're doing, the problem you're up against, and your assessment of the available options.
Just remember to keep it to one page and focus on the things your leaders care about the most.

# Stuff happens

No matter what you do, stuff happens.
Systems break.
People get sick.
Plans change.

Do your best to be flexible and set the right expectations.
One of my childrens' preschools had a great motto around snack time that applies here:

> You get what you get and you don't throw a fit.

Your team can only deliver so much.
Take any shortcomings or feedback as a learning opportunity for next time.
Set up retrospective meetings to identify what went well and what didn't.
Be sure to share these learnings with other teams, too!

Finally, **take time to celebrate the win when you finish.**
I recently worked with a great team on a product that launched during a big keynote presentation at a company event and it was an amazing feeling.
Sure, our product had plenty of rough edges and room for improvement, but at that moment, we delivered.
