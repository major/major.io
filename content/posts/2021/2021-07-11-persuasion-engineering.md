---
author: Major Hayden
categories:
- Blog Posts
date: '2021-07-11'
summary: >-
    Improve your persuasive skills to get your team on board with solutions to
    tough problems. 🤔
images:
- images/2021-07-11-uk-hill.jpg
slug: persuasion-engineering
tags:
- advice
- career
- mentorship
title: Persuasion engineering
type: post
---

{{< figure src="/images/2021-07-11-uk-hill.jpg" alt="Hill in Derbyshire, UK" position="center" >}}

Mentorship stands out as one of my favorite parts of working in technology and
I've been fortunate to be on both sides of mentoring relationships over the
years. One common aspect of career growth is the ability to come up with a
solution and then persuade other people to get on board with it.

Not every change is a winner, but if you feel strongly that your solution will
improve your product, transform your customer experience, or just make
everyone's lives a little easier, how do you convince other people to join you?

This post covers several lessons I learned while trying to convince others to
join me on a new technology trek. Although there's no perfect answer that fits
all situations, you can use bits and pieces of each of these to improve your
persuasion skills at work.

## Make the problem real

> "Fall in love with the problem, not the solution." &raquo; Uri Levine,
> co-founder of Waze

Technology exists to solve problems, but engineers often lose sight of the
problem they want to solve. This makes persuasion difficult. Before you can
propose a solution and get others interested in contributing, you must identify
and get agreement on the problem.

However, not everyone sees problems the same way. Some may see your problem as a
non-issue since it doesn't affect them. Others may see your problem as an issue
to fix, but other issues are more pressing. A smaller set will likely see the
problem the same way you do, but they have other ideas for solving it. *(Don't
worry about this for now. More on that later.)*

My journalism teacher in grade school always told us that stories that focus on
people and their experiences, called "feature stories", always generate more
attention. But why? Feature stories talk about people and their experiences,
often by allowing the people to tell their own story in their own words. They
make the story **real** for more readers. When you finish reading, you know
**what** happened and you know **how it affected real people**.

Discussing problems works the same way. The problem becomes real not when it is
explained or presented, but when your audience understands how it affects
people. Let affected people speak for themselves by gathering comments from
customers or coworkers to accelerate this process.

Let's say there's a performance issue in your technology that affects large
customers and they experience slow performance. You've identified the root of
the problem and you're eager to solve it. A basic approach might go like this:

> "Large customers are upset because our web interface is too slow when loading
> their data. We must fix our database server soon."

This is okay, but what if we expand it a bit and make the problem more real for
everyone?

> "Several of our large customers are frustrated because their account listings
> take too long to load in our web application. For some customers, such as
> Company X, the wait time is over 60 seconds and they often can't get their
> data at all. Beth from Sales says she has three large customers who want to
> renew but want this problem fixed first. That's $500,000 in renewal income
> that we could lose. Dan from Support says his team spends too much time on
> these issues and their ticket queues have increased 30% -- the customer NPS
> surveys are down, too. This could affect our upcoming presentation at
> Conference Y where we've paid for a prime sponsorship slot. Our database
> administrators explained that they are having difficulty making backups since
> the database servers are incredibly busy. This may affect our business
> continuity plans."

What's different with the second approach?

* The problem now has multiple real impacts on multiple teams.
* Revenue loss hangs in the balance since we're unsure about renewals or getting
  our money's worth for our conference sponsorship.
* Customers are not being well served by support.
* A potential emergency event looms in the future without good backups.

We've turned a problem statement into a feature story. Your audience has heard
about the problem, but they also *feel* the problem. They know how it is
affecting their coworkers, but most importantly, they understand how it is
affecting customers.

This *feeling the problem* step is critical and often overlooked. You're making
an appeal to the *emotions* of your audience first, followed by an appeal to
their *reasoning*. That leads well into the next section.

## Appeal to emotions

> "The weakness of the Elephant, our emotional and instinctive side, is clear:
> It’s lazy and skittish, often looking for the quick payoff (ice cream cone)
> over the long-term payoff (being thin). When change efforts fail, it’s usually
> the Elephant’s fault, since the kinds of change we want typically involve
> short-term sacrifices for long-term payoffs." &raquo; Chip Heath,
> [Switch](https://heathbrothers.com/books/switch/)

In the fantastic book *Switch: How to Change Things When Change is Hard*, Chip
and Dan Heath talk about the elephant as a metaphor represents our emotions.
Emotion drives everything we do (and don't do), and you can't use reasoning with
someone if their emotions are not on board.

Think about a child with an ice cream cone and the ice cream falls to the
ground. The child screams and screams because they feel like a great experience
was taken from them. A parent might say "It's okay! We can get another one!",
but the child continues to scream. But why? Getting another ice cream is easy
and they still get to enjoy the experience.

At that point, the child's emotions are completely overwhelmed. Reasoning won't
work. That part of the brain is like a rider on an elephant. If the elephant is
frightened by something or feels strongly about going a certain direction,
there's nothing that rider can do to change its mind. The only way to get back
on track is to appeal to the child's emotions *("That's terrible. I know. Here,
I'll give you a hug")* until they are calm, and then apply some reasoning *("Can
I get you another ice cream? Would you like the same flavor?")*.

Everyone's emotions are triggered and managed differently, so it's best to cast
a wide net. In the example from the last section, we talked about losing money,
dissatisfied customers, and potential mortal danger to the company. The goal is
to make an appeal on multiple levels in the hopes that at least one will catch
the attention of someone's elephant (their emotions).

As a software developer, the best reward you can get is when someone uses what
you wrote and they enjoy using it. If I learn that someone is dissatisfied with
something I made, I want to know everything I can about it. Their
dissatisfaction triggers my emotions. It's one of the strongest appeals that
makes me want to stop what I am doing and improve what I've created.

You have two main goals here:

1. Appeal to the emotions of people who are unaware of the problem or who
   prioritize the problem lower than you do.
2. Appeal to the emotions of people who are very aware of the problem and
   reinforce that their voice has been heard and understood.

## Work backwards to move forward

> "When solving problems, dig at the roots instead of just hacking at the
> leaves." &raquo; Anthony J. D'Angelo

Your next step is to work backwards to ensure you've found the root of the
problem. There are plenty of methods to work through the process, but keep in
mind that it is a *process*. The process brings you closer to the root of the
problem to ensure you're solving the right problem.

One of my favorite methods is the Five Whys. It really just involves asking
*why* until you get that feeling that there's nothing else to ask. This is a
great activity to do on your own before bringing it to the group. It helps you
anticipate different conversations and prepare for them. Do the same process
with the group, too.

Going back to our example from the first section, it could go something like
this:

> Our web interface is too slow for our largest customers.
>
> Why?
>
> The web interface sits around for a long time to get data from the database.
>
> Why?
>
> The database takes too long to send data back.
>
> Why?
>
> There's a lot of data to retrieve and the queries take a long time to run.
>
> Why?
>
> We store data that we don't need and our queries retrieve more data than we need.
>
> Why?
>
> We've never optimized this part of our application before.

Awesome! What did we learn about the problems we need to solve?

* Database queries need to retrieve the least amount of data required by the web
  application.
* Some information in the database might need to be cleaned up or moved
  elsewhere.
* Database queries might need some optimization in general.
* The connection between the web and database servers might need to be improved.
* Future features should include considerations or questions around how it
  affects data retrieval times from the database.

Now we have a list of problems to solve and some things that need consideration
during future development. This leads us to consider short, medium, and long
term solutions, and that's our next step.

## Solutions that last come last

> "Every problem has in it the seeds of its own solution. If you don't have any
> problems, you don't get any seeds." &raquo; Norman Vincent Peale

Everything we've done has led to this moment. We need solutions to our problem
from the first section. In a previous life, I was an EMT on ambulances and we
faced constant problems. Some were immediate and life-threatening while others
could become an emergency over time.

We can think through the solutions process in much the same way as I approached
patients on the ambulance. I use this process:

1. **Short term:** What *must* be solved right now to alleviate pain and stop
   the bleeding? Other things may need to be done after, but what must I do
   *right now*?
2. **Long term:** What are the complicated things we need to do that will take
   some time, but are still very important?
3. **Medium term:** What things are complicated but important that can be solved
   by changing how we work or adopting better processes going forward?

You may wonder why the medium term tasks come last. I keep them at the end
because as you argue about the short and long term items, you'll have work that
lands in *gray areas* between short and long term. For example, you may want to
fix a critical problem, but fixing it involves lots of planning or organization
with other groups. Sure, it's critical, but it's not something you can do
quickly.

Short term solutions should obviously be critical ones, but they should be ones
that can be done by smaller group of people. Some might call these "low-hanging
fruit". These are the things where you look at a coworker and say "Hey, let's
sit down and try a few different fixes to see which one works best." Avoid
anything here that requires wide cooperation or regulatory changes. You want the
changes to quickly snowball into big improvements so everyone can *feel* that
something is getting better.

From our example, short term things might be:

1. Identify the queries that are retrieving too much data and inventory what
   data is actually needed.
2. Deploy a backup read-only copy of the database server to take backups.
3. Get a list of customers who are willing to try a preview of the newer, faster
   web interface.

Next, look for the long term solutions. These are things that require multiple
groups to collaborate, consultations with vendors, or regulatory changes.
Although these may take a while, the building momentum from the short term
changes should build confidence that these can get done.

These might include:

1. Migrate the database to a faster server.
2. Consult with auditors to understand what data could be removed over time and
   adjust customer agreements accordingly.

Finally, the medium term solutions are made up of those things that fit in
between short and long term things. The best solutions here are process-based to
reduce the chance of the problem happening again before long term solutions are
implemented.

From our example, this could be a new process added to quality assurance that
checks web interface performance after any feature or bug fix is proposed. The
CI system could do a test to see if response times improved or worsened after
the change. This would allow developers to determine which changes must be held
back until performance reductions are fixed. These medium term solutions ensure
that the problem doesn't worsen before the long term issues are fixed.

## Measure, report, and repeat

The solutions snowball should continue to build over time as problems are
crushed one by one. The maintenance of this momentum drives everything forward.
Ensure that you measure the impacts of these changes over time and let everyone
know about the progress.

Take time to celebrate the wins, no matter how big or small. This builds
comradery among the teams and reminds people less about the problem and more
about how they overcame it. I have t-shirts in my closet from big solutions to
big problems from my previous work.

Sure, people remember the problem that started it all, but they remember the
hard work that came afterwards so much more.

If you've seen the movie Apollo 13, where a failed trip to the moon put three
astronauts in mortal danger,  what do you remember most?

Do you remember what broke on the spaceship? I do. It had something to do with
oxygen tanks.

What do you really remember from the movie? I remember three astronauts and a
ton of people back on Earth working through plenty of solutions and eventually
succeeding. I remember everyone trying to figure out how to filter out carbon
dioxide with the wrong parts. I remember three astronauts making it back to
Earth with the world watching. I remember seeing people relieved and amazed by
the work they did how they turned an awful situation into an unforgettable
ending.

**What will your coworkers remember?**

*Photo credit: [Giulia Hetherington on Unsplash](https://unsplash.com/photos/ODNmaOlV75c)*
