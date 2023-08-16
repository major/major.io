---
author: Major Hayden
date: '2023-08-16'
summary: >
  Want to make a change in an open source project?
  Take the Nike approach and Just Do It. 👟
tags:
  - advice
  - development
  - open source
title: "Open source contributions: Just do it"
coverAlt: Red Nike sneaker with a white check/swoosh on a red background
coverCaption: |
  [Domino](https://unsplash.com/photos/164_6wVEHfI)
---

I had a great time on the [Fedora Podcast](https://www.youtube.com/watch?v=aA-pBYxUPgU) yesterday to talk about Fedora cloud!
We talked about all kinds of Fedora-related topics, but a couple of questions came up around how to contribute, especially when there's not a lot of structure in place for a particular type of contributions.
Here's the full video if you're interested:

{{< youtube id="aA-pBYxUPgU" autoplay="true" >}}

That made me think about a post that deserves to be written:
**How do you get started with open source contributions in a new project?** 🤔

My answer is pretty simple:
**Just do it.** 🚀

# Just do what?

In the late 1980's, one of Nike's ad agencies [came up with the phrase](https://en.wikipedia.org/wiki/Just_Do_It) as a way to push through uncertainty.
I was pretty young when this campaign started, but the general idea was this:

* Anyone can achieve what they want
* Stop worrying about whether you can actually do something
* Try something new
* Just do it

Simple, right?

This works for open source contributions, too.
I often have conversations with people inside and outside of work where they identify a problem or an improvement in an open source project.
My customary response is _"Let's go upstream and make this better!"_

However, what I hear back most often is _"I don't know how."_
This is where the whole **just do it** part comes in.

# I found a bug

Nearly every open source project wants to know about bugs that users experience.
Start by finding out the best way to communicate with the people working on a particular project.

For projects on GitHub or GitLab, you can open up an issue and describe your problem.
Some repositories have a template generated for bugs that ask you several important questions, so be sure to follow those templates.
If there isn't a template, I usually follow this format:

* What happened that was unexpected?
* What were you doing right before that unexpected event happened?
* What did you expect to happen instead?
* What else is nearby in the environment that might have an impact?
  * For example, the versions of Python might be important for Python-based projects.
* What log files or other diagnostic materials exist?

What's the goal?
We want to give maintainers enough information for a quick diagnosis in the best case.
If it's not obvious, then they need enough information to try to reproduce it on their own machine for debugging.

Maintainers might come back with additional questions about your environment or the events just before the bug occurred.
Be sure to respond in a timely way while the information is top of mind for them.

**Always remember that these maintainers are real people who are likely not being paid for their work.**
Assume the best of intentions (unless proven otherwise) and stay focused on the solution.
There might always be the chance that the maintainers are not interested in your use case and might not be interested in solving it.

That leads me to the next step.

# I found a bug and I want to fix it

Start by opening an issue or a bug report first (see the previous section).

This ensures that maintainers get a full picture of the problem you're trying to solve.
Also, I've had maintainers immediately reply and tell me that it's a known issue already being solved in another issue.
That could save you some work.

If you have a patch that fixes the issue, go through the following steps before submitting the fix upstream:

* Ensure your fix references the issue or bug report that you opened
* Use a very clear first line in your commit message, such as `parser: Fix emoji handling in YAML` rather than `Fix YAML bug`
* Include a very brief explanation of the bug you're fixing in the commit message
* **Extra credit:** Add or update existing tests so they catch the bug you just found
* **Extra credit:** Add or update the project documentation for your change if necessary

These extra credit items often make it easier to review your patch.
Maintainers love extra test coverage, too.

Submit your change in a pull request or merge request and watch for updates.
Be patient with replies from the maintainers, but be timely in your replies.
Remember that your use case might be an edge case for the upstream project and you might need to explain your fix (or the original bug) in more detail.

# I want to improve something

Improving an open source project could involve several things, such as:

* Enhancing by adding a new feature
* Optimizing an existing feature
* Creating documentation
* Building integrations

I strongly recommend opening an issue first with the project maintainers to explain your enhancement.
These _Requests for Enhancements_, or RFEs, should include several things:

* Your use case that made you think of the enhancement in the first place
* What you plan to add, substract, or change
* How the changes might affect different users, especially as they upgrade from older versions
* How the changes might affect testing or release processes
* Any changes in dependencies required

Before going down the road of enhancements, always bring up these ideas with the maintainers first.
You want to ensure that your ideal changes are aligned with the future goals of the project.
In addition, maintainers will want to better understand your use case.

Remember that an enhancement almost always requires additional work from maintainers.
Every new use case means more work to ensure the project still functions.
That's why it's critical to share your use case and have a good plan for testing and documentation.

# Getting involved

Whenever I find an open source project that I'd like to get involved with, I start looking around for several things:

* **What do they use for informal asynchronous chat?**
  IRC? Matrix? Slack? Something else?
  I join the chat, introduce myself, and get an idea for how they interact.
  Some groups are very chatty and informal while others are much more formal and regimented.
* **Where do they have detailed discussions?**
  Many projects have detailed discussions in their issues/bugs or in places like GitHub's discussions.
  Others use [old school mailing lists](/p/mailing-list-beef/).
  Some groups have regular meetings where anyone can add agenda items for discussions.
  If I need to talk about something a bit more long form and I expect some back and forth on it, I look for this avenue.
* **What requirements exist for contributors?**
  Some projects require that contributors sign a [CLA](https://en.wikipedia.org/wiki/Contributor_License_Agreement) or some other sort of agreement.
  Make sure that any CLAs you sign are approved by your employer (if applicable).
  You might need an account on a system that you don't have, so check for that as well.

From there, I take the **just do it** mentality and go for it.
The worst thing you'll be told is _"No"_.
If that happens, take a step back, see if there's another way to approach it, and try again.

Remember one thing most of all: **avoid taking anything personally.**
All of us have our bad days and some people have personalities that might be totally incompatible with yours (and most people in general). 🤭