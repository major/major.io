---
author: Major Hayden
date: '2026-11-10'
summary: Lots of companies are embracing token budgets for AI coding harnesses, but do they support the right behaviors? 
tags:
- advice
- ai
- software development
title: On token budgets
---

It's no secret that frontier AI models quickly become expensive even for careful users.
Some companies tackle this challenge with token budgets for employees.
Employees find themselves with a limit on how much they can spend per month or access to certain models might be reduced.

Companies hope that this encourages employees to conserve their AI usage and find ways to do more with fewer tokens.
Does it really drive the right behaviors?

I gathered some information from several people I know who are working at various companies, large and small, that are somewhere on their journey of limiting token spend per employee.

# Exceeding the budget: what do you do?

Let's assume a company gives an employee a monthly budget for AI tokens.
The employee reaches the budget limit halfway through the month.
What are their options now?

* **Stop working:** This isn't a good option for remaining employed.
* **Traditional, manual work:** Writing code, reviewing code, and planning work goes back to the pre-AI days. Slow.
* **Employee gets personal subscriptions:** Saves the company money, but there's a huge risk for information security and privacy.
  Employees might find themselves at odds with company compliance requirements.
* **Additional budget:** Companies could allocate more funds on request, but that becomes a speed bump and red tape.

Some companies use a soft/hard limit where you get a warning that you crossed the soft limit before the hard limit is applied.
This allows employees to know when they're at risk of reaching the limit and they're able to ask for more quota prior to running into the hard limit.
It's still red tape, but at least it doesn't become a blocker immediately.

# What gets prioritized?

Imagine you're an employee on a token budget.
What work would you prioritize if you know your token budget is limited?
A lot of this depends on how you're evaluated at work.

Let's consider an employee named David.
He's a software engineer on a team of developers responsible for adding features to an application and fixing buge on that same application.
David's manager evaluates him on how he works with his team to launch the next version of their product.
If David knows he's on a token budget, what will he prioritize?

1. Translating Jira tickets into plans
2. Building pieces of a feature
3. Fixing bugs assigned to him
4. Reviewing other people's code
5. Anything else

If David knows he's at risk of hitting his token budget and that might prevent him from meeting his performance goals at work, how much will he prioritize doing code reviews for his coworkers or fixing issues outside of the ones he's assigned?
Some employees might do these things knowing that these indirect actions benefit the team and help everyone succeed.
However, in some large organizations, this might set you behind personally even if your team meets their goals.

Some friends have told me that at their companies, token budgets sometimes push people towards fixing what's _required_ -- and no more.
Production code refactors and test suite cleanups can totally be done by hand, but if they're not part of your performance review and they might push you over your token limit, they're likely to be left alone to fester.

# Do we need training?

Some companies that set token budgets offer training or encourage employees to share how they are limiting their token spend.
It's really easy to get started with a coding harness, pick an expensive model (it's often the default!), and burn through a budget without even noticing.
I regularly hear about people hitting one million token limits with a model and running into a forced compaction.

Employees _definitely_ need training and examples of ways to be more token efficient.
(I still need to write a post on this topic.)
It's easy to tell people "just use agents".
That's a mindset shift much more than a technology change.

Some of my strategies include:

* Using subagents for common activities, such as fixing, exploring, and researching, to keep the main session context as clean as possible.
* Using the right model for the right agent to save money.
* Reducing skills down to the fewest number of skills, each as brief as possible.
* Cutting core instructions (think `AGENTS.md`) down to the bare minimum that applies to over 90% of sessions.
* Codifying repetitive tasks into token-efficient commands that are more deterministic.
* Asking the coding harness to examine an expensive session to find cost savings.
* Building my own MCP servers that gather data from other systems in a highly LLM-friendly manner.

Companies need to offer employees more than one approved coding harness, too.
Claude Code and OpenAI Codex are great, but employees might find more productivity gains with OpenCode, goose, or pi.
There should also be places internally where employees using various harnesses can share their productive patterns.

# Have we seen this show before?

We have!
I remember the early days of deploying public cloud infrastructure and it felt like a free-for-all from the start.
As people broke free from the shackles of physical hardware and capital expenditures, cloud deployments grew like weeds.
Everything moved at the speed of light until... the bill arrived.

Remember FinOps?
That spun out of the need for companies to keep deploying cloud infrastructure at a rapid pace without blowing out the budget.
Teams suddenly began looking for cost savings in various ways:

* Reducing the size of deployed cloud instances
* Configuring private network traffic
* Picking the right object storage class and cleaning up old objects
* Choosing the most efficient block storage types
* Splitting workloads onto multiple instances or consolidating workloads
* Switching cloud providers

None of that was fixed overnight.
We all had to learn where we were spending our money, where we were overspending, and what options were available for spending less.
All of us undersized instances for workloads at least once.
Network connections evolved into more complex spiderwebs of private (unbilled) networks.
Most of us tried to do multi-cloud and failed badly at it. 😂

**Reducing AI spend requires us to learn as we did with cloud deployments:**

* Where are we spending too much?
* Why are we spending too much?
* What other options are available?
* How do we make it _easy_ to be token-efficient?

My hope is that token budgets will always come with this education component.
Otherwise, this puts more stress on employees as the world of software development iterates faster and faster.

I'll have some posts coming soon about some of the strategies I've used over the past year.
