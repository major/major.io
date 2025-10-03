---
author: Major Hayden
date: '2025-06-01'
summary: |
  Although Scrum is a popular agile methodology, it often becomes a theater of activity
  that distracts teams from what customers actually need. 📅
tags: 
  - agile
  - advice
  - software
title: Scrum, sprints, and outcomes
coverAlt: Red poppies bloom against a dark blurred background
coverCaption: |
  Photo by <a href="https://unsplash.com/@insungpandora?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">insung yoon</a> on <a href="https://unsplash.com/photos/red-poppies-bloom-against-a-dark-blurred-background-Y9YBsEFZikw?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>  
---

Most software developers have come across [agile software methodologies] such as [Scrum].
At its core, Scrum's goal is to help teams deliver software in smaller chunks over a set period of time, called a sprint.
Teams should be able to work better together, deliver more frequently, and adapt to changes more easily.

[agile software methodologies]: https://en.wikipedia.org/wiki/Agile_software_development
[Scrum]: https://en.wikipedia.org/wiki/Scrum_(software_development)

**However, Scrum often becomes a theater of activity -- story points, velocity charts, and ceremony compliance -- that distracts teams from what customers actually need.**

# What is Scrum?

This could be a whole post in itself, but in my experience, Scrum revolves around a few core tenets:

* **The work.**
  Development, quality, and research work is time-boxed into a sprint, most often lasting two weeks.
  You cobble together a list of tasks (or tickets) together that you believe you can complete within the sprint.
* **The team.**
  There's obviously a development team, but there are two other roles involved.
  The product owner helps with prioritizing work, organizing the backlog of to-do items, and ensuring that the team is working on the right things to deliver value for customers.
  A scrum master is almost like a specialized project manager who helps the team stay on track, removes roadblocks, and ensures that the team is following Scrum practices.
* **The ceremonies.**
  I use *ceremony* here slightly facetiously, but most Scrum teams have a set of meetings that they hold regularly.
  There are daily standups, sprint planning meetings, sprint reviews, and retrospectives.
  The goal is to make the next sprint better than the previous one and surface problems.

When this works well, most people on the team are aware of what others are working on and where they might be struggling.
Other adjacent teams, such as marketing or sales, can align their work so that they're fully prepared to bring those products or improvements into customers' hands.

**It's not all a panacea.**
Let's discuss why.

# Estimations and exploratory work

The world has many, many trades where you can estimate the time and complexity of your work before getting started.
If you call a plumber for a leaky pipe, they can estimate the cost and time required to fix it with reasonable accuracy.
When your car has a flat tire, the mechanic can tell you how long it will take to fix it and how much it will cost.

**Software development is inherently _exploratory_.**
That's because it involves building something that didn't exist previously.
Sometimes there are tools and libraries that speed up development, but these often have limitations that require research.

As an example, I recently worked on a project that involved adding lots of documents to a retrieval-augmented generation (RAG) system.
This is a method for giving an AI model access to information to answer questions that it didn't know already.

Another team had great results with a particular database and mechanism for adding documents, so I was able to utilize most of their strategy.
Everything looked like it would be straightforward.
An easy ticket with a low estimate; who doesn't love that?

Then things changed.

* The database worked well for their use case, but I had no idea that they were working with a small number of high quality documents in a consistent format.
  My documents had varying structure, varying quality, and we had a lot more of them.
* Our RAG database build times were much longer than theirs, so we had to search for infrastructure that would allow us to build ours faster.
* Their embedding model for turning text into vectors for a semantic search worked well for their documents but it didn't work for ours.
* We found a better database, but then we had to find out how we could deploy and manage it following our company's procedures.

What we thought would be done in a couple of weeks suddenly took a couple of months.
We had to come up with new strategies and also think differently about what we would do before and after the RAG search to improve its quality.

**Time-boxing this work into a sprint was extremely difficult.**
Estimation was even more difficult because we didn't know the complexity involved and how long it would take.
Some of the complexity questions couldn't even be answered because we had dependencies on other teams to complete the work.

This means we were breaking Scrum's core tenets constantly to deliver the features:

* We added tickets to sprints after the sprint opened
* We carried lots of issues over to the next sprint as we added new tickets to that sprint
* Estimates were wildly inaccurate

In the end, we did deliver what was needed, but we often wondered why we were still putting such a heavy emphasis on Scrum.

# Interruptions

Interruptions are a fact of life.
The Linux kernel deals with this via aptly named interrupts, and it receives signals that something needs attention.
It could be events coming from a keyboard or mouse, network packets waiting to be processed, or any number of timers running on the system.
The kernel is well suited to handle many of these smaller interrupts.
Larger ones lead to heavy context switching and these strain the system.

Software developers are no different.
I work with brand new software developers and interns who need guidance from time to time on how to attack a problem.
These interruptions are great!
Someone gains a new skill and can do more than they previously could.
I also reinforce my own knowledge by teaching them.
It's usually on a topic that I know well and often tangentially related to what I'm working on anyway.

Getting into a meeting with multiple engineers on Google Meet to argue about story points, burn down charts, sprint velocity, and other metrics is a different story entirely.

During a two week sprint at various companies, I've found myself spending a decent amount of time doing things other than software development:

* **Daily standups.[^async standup]**
  Everyone shares what they completed yesterday, what they completed today, and any blockers they have.
* **Sprint planning meetings.**
  The team brings together their tickets to plan out what will be included in the next sprint.
  This is often when a sprint is closed and the next one is opened.
  You have these every two weeks if you're doing two week sprints.
* **Sprint reviews and demonstrations (demos).**
  Some organizations combine these two together, but the goal is to share what was completed during the sprint and demonstrate how any new features work.
* **Retrospective.**
  Once a sprint has finished, the team meets to discuss what worked, what didn't work, and what needs to be changed in the next sprint.
  These often occur once the next sprint has already started, so the team is already in the middle of the next sprint while discussing the previous one.

Standups are excellent, especially for teams with new developers.
The other meetings can quickly become a burden.

If we assume standups are 10 minutes per day and the remaining meetings all last an hour each, that's just under five hours of meetings per two week sprint.
That doesn't include other meetings, such as team meetings, company wide meetings, one-on-ones, and mentorship.

You might think that's not terrible, but consider that these tickets must be written, estimated, reviewed, and prioritized prior to the sprint planning meeting.
Demos must be built and prepared for the sprint review.
Retrospectives require the team to think ahead of time about their work before the meeting and then think about how to implement changes after the meeting.

These interruptions can quickly stack up.
**When you combine software development's exploratory nature with constant ceremony interruptions, you create a recipe for burnout.**
We should be focused on delivering an outcome or helping a teammate deliver an outcome.
Scheduling these around sprint ceremonies wastes time and energy.

[^async standup]: There are synchronous (everyone gets in a meeting together at the same
  time) and asynchronous (everyone puts their updates in a central place for later
  review). The async standups definitely save time, but then you lose the ability to ask
  questions and many developers forget to read the updates.

# Activity over outcomes

When you sit down in your new car for the first time or hold that latest smartphone, you're probably not wondering how many sprints it took to build it.
The look of the company's velocity or burn down charts probably won't cross your mind.

**As the customer, you're focused on the outcome.**

You name it, I've probably done it at one company or another.
Scrum.
Waterfall.
Continuous flow.
Kanban.

Any of these turns toxic as soon as the focus is on the activity rather than the outcome.
Focusing on the activity means putting tons of weight on the processes, the meetings, and the metrics.
It means you _say you're interested in the outcomes_, but you don't practice that from day to day.

If you want to ensure teams deliver process compliance instead of customer value, lean in really hard on the agile process.
Developers work around these processes by doing quite a few unhelpful things:

* Avoid creating tickets or create far too many tickets.
* Locking themselves into a solution prematurely to ensure something gets done within the sprint.
* Sandbagging estimates to buy time or make things fit into a sprint.
* They redefine what "done" means and then add bugs or refinements to later sprints.
* Turn Scrum processes into "meeting theater" where everyone goes through the motions but nobody really cares about the outcome.

None of these benefit the team, the leaders, or the end customer.
It also pushes developers to look for other teams or other companies that are more focused on outcomes.

**The honest answer is that nobody knows when software will ship.**
No matter what methodology you use or how hard you push on the agile process, you can't predict the future[^date-driven].
Software development is complex, customer demands change constantly, and new technologies emerge daily.
What makes sense on day one of the sprint may not make sense on day 14.

It doesn't have to be this way.

[^date-driven]: There is a concept of "date driven development" where something must ship on time, and in that case, you can drop features or capabilities to ensure on time delivery.
  You just don't be sure how many features and capabilities the product will have when it ships.

# What do we do?

**Everything that a team does must be focused on outcomes.**
This isn't the activity that delivers an outcome, but the outcome itself.

In the past, I worked on a team where we ran Kanban instead of Scrum and we had a "theme" that we worked toward.
Kanban is more of a continuous flow methodology with a limit on work in progress items and without a defined time for work.
It wasn't the methodology that made us successful.
It was the focus on the theme.

For example, we had some themes such as "deliver feature X" or "improve cost efficiency of Y to x%".
Everyone on the team, including developers, quality engineers, and documentation experts all knew the goal.
We could work on whatever we needed to in order to achieve that goal but we could not exceed our work in progress (WIP) limits.

As you might expect, someone said _"Hey, what happens if we hit the WIP limit?"_
Our astute manager at the time knew she had hired talented people who are great at solving tough problems and she was ready with her answer: _"That's for you to figure out."_

Something interesting happened when we hit the WIP limit for the first time.
Sure, the column in Jira turned red and someone mentioned it in Slack, but that isn't what I'm talking about.
Someone was freed up on their task and realized they couldn't pull anything else into the "in progress" column.

They looked in the column for a minute and discovered an issue that was really familiar to them, but it was assigned to someone else.
They asked the person working on it if they needed help and the person assigned to the ticket said: _"Yeah, I think I'm stuck!"_
It turned out to be a great teaching and mentorship opportunity.

We saw several benefits from being focused on the outcome and not the activity:

* The "stuck" issue didn't appear in the daily standup because the developer was afraid to raise it.
  That fear was solved by another developer joining in when the WIP limit was hit.
* Team members focused heavily on the "in progress" column and we discovered that we didn't need standups as often.
  The goal changed to "let's figure out these stuck issues" organically.
* The theme was our "rally cry" going forward.
  We all knew what we were working towards and why we were doing it.
* Estimating issues turned into more of a discussion of what was involved in solving the issue instead of an exercise in futility.
* Our product owner only needed to ensure the "to do" column was cleaned up and prioritized.
  Everyone knew where they needed to pull work from first.

We still had date constraints, but the **dates were related to when we needed to deliver something to the customer**, not arbitrary dates that we set for ourselves.
We all knew the dates, the goal, and the overall mission.
We knew the what, the how, and the why.

# Summary

Scrum often transforms software teams into process performers rather than problem solvers.
Lighter processes that reinforce the _right behaviors_ deliver more value for teams and helps them focus on outcomes.
When teams are focused on outcomes, they can adapt to changes, solve problems, and deliver more value to customers.
When teams know their "why," they'll figure out the "what" and "how" without rigid processes.
