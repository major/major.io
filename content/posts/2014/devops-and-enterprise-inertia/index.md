---
aliases:
- /2014/04/17/devops-and-enterprise-inertia/
author: Major Hayden
date: 2014-04-17 17:46:25
tags:
- development
- devops
- general advice
title: DevOps and enterprise inertia
---

As I wait in the airport to fly back home from this year's [Red Hat Summit][1], I'm thinking back over the many conversations I had over breakfast, over lunch, and during the events. One common theme that kept cropping up was around bringing DevOps to the enterprise. I stumbled upon [Mathias Meyer's][2] post, [The Developer is Dead, Long Live the Developer][3], and I was inspired to write my own.

Before I go any further, here's my definition of DevOps: _it's a mindset shift where everyone is responsible for the success of the customer experience_. The success (and failure) of the project rests on everyone involved. If it goes well, everyone celebrates and looks for ways to highlight what worked well. If it fails, everyone gets involved to bring it back on track. Doing this correctly means that your usage of "us" and "them" should decrease sharply.

### The issue at hand

One of the conference attendees told me that he and his technical colleagues are curious about trying DevOps but their organization isn't set up in a way to make it work. On top of that, very few members of the teams knew about the concept of continuous delivery and only one or two people knew about tools that are commonly used to practice it.

I dug deeper and discovered that they have outages just like any other company and they treat outages as an operations problem primarily.  Operations teams don't get much sleep and they get frustrated with poorly written code that is difficult to deploy, upgrade, and maintain.  Feedback loops with the development teams are relatively non-existent since the development teams report into a different portion of the business.  His manager knows that something needs to change but his manager wasn't sure how to change it.

His company certainly isn't unique.  My advice for him was to start a three step process:

### Step 1: Start a conversation around responsibility.

Leaders need to understand that the customer experience is key and that experience depends on much more than just uptime. This applies to products and systems that support internal users within your company and those that support your external customers.

Imagine if you called for pizza delivery and received a pizza without any cheese. You drive back to the pizza place to show the manager the partial pizza you received. The manager turns to the employees and they point to the person assigned to putting toppings on the pizza. They might say: "It's his fault, I did my part and put it in the oven." The delivery driver might say: "Hey, I did what I was supposed to and I delivered the pizza. It's not my fault."

All this time, you, the customer, are stuck holding a half made pizza. Your experience is awful.

Looking back, the person who put the pizza in the oven should have asked why it was only partially made. The delivery driver should have asked about it when it was going into the box. Most important of all, the manager should have turned to the employees and put the responsibility on all of them to make it right.

### Step 2: Foster collaboration via cross-training.

Once responsibility is shared, everyone within the group needs some knowledge of what other members of the group do. This is most obvious with developers and operations teams. Operations teams need to understand what the applications do and where their weak points are. Developers need to understand resource constraints and how to deploy their software. They don't need to become experts but they need to know enough overlapping knowledge to build a strong, healthy feedback loop.

This cross-training must include product managers, project managers, and leaders. Feedback loops between these groups will only be successful if they can speak some of the language of the other groups.

### Step 3: Don't force tooling.

Use the tools that make the most sense to the groups that need to use them. Just because a particular software tool helps another company collaborate or deploy software more reliably doesn't mean it will have a positive impact on your company.

Watch out for the "[sunk cost][4]" fallacy as well. [Neal Ford][5] talked about this during a [talk at the Red Hat Summit][6] and how it can really stunt the growth of a high performing team.

### Summary

The big takeaway from this post is that making the mindset shift is the first and most critical step if you want to use the DevOps model in a large organization. The first results you'll see will be in morale and camaraderie. That builds momentum faster than anything else and will carry teams into the idea of shared responsibility and ownership.

 [1]: http://www.redhat.com/summit/2014/presentations/
 [2]: https://twitter.com/roidrage
 [3]: http://www.paperplanes.de/2014/4/17/the-developer-is-dead.html
 [4]: https://en.wikipedia.org/wiki/Sunk_costs
 [5]: http://nealford.com/
 [6]: http://nealford.com/downloads/Agile_Architecture_and_Design(Neal_Ford).pdf