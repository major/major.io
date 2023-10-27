---
author: Major Hayden
date: '2023-10-27'
summary: >
  Moving to cloud is about much more than just capital efficiency. It enables your teams
  to do more if they're willing to adopt some new practices.
tags:
  - cloud
title: Moving to cloud is more than just a purchasing exercise
coverAlt: Glass jars of herbs on a shelf with labels of their contents
coverCaption: |
  Credit: [Piotr Makowski](https://unsplash.com/photos/black-horse-chess-piece-near-roque-chess-piece-27LH_0jXKYI) via Unsplash
---

Much of my work at Red Hat revolves around the RHEL experience in public clouds.
I thrive on input from customers, partners, and coworkers about how they consume public clouds and why they made decisions to deploy there.

Throughout this process, I run into some wild misconceptions about public clouds and what makes them useful.
One that I hear most often is:

> Businesses are moving to the cloud to reduce cost and improve efficiency.
> It's mainly just a purchasing exercise.

This couldn't be further from the truth.

# Cloud offers a chance to start over

Sometimes businesses find themselves in an IT quagmire[^quagmire].
No matter what they do to improve their situation, it just gets worse.
Capital expenditures grow and grow, datacenter space gets more expensive, and companies spend more time focusing on IT rather than their core business.

Deploying in clouds offers that chance to break the capital expense cycle and gradually improve infrastructure.
The key word here is *gradual*.

Businesses can choose how much they want to deploy and when without worrying about expensive servers in the datacenter waiting to be used.
Some deployments are greenfield, or entirely net new applications.
Some are basic migrations of applications from servers or virtual machines directly to the cloud.

Either way, businesses have the freedom to deploy as little or as much as they want on their own schedule.

# Cloud offers a chance to software-define (nearly) anything

Anyone who has worked in a large organization before knows the pain of change management.
Sure, it ticks a box on that yearly compliance program, but it also ensures that everyone is aligned on the plan.

One of the greatest aspects of cloud is that you can define almost everything in software.
This makes changes easier to apply, easier to roll back, and easier to track.

Tools like [Terraform](https://www.terraform.io/) or [Ansible](https://www.ansible.com/) allow developers and operations team to work from the same playbook.
My team enjoys using [Infracost](https://www.infracost.io/) to track how much a particular Terraform change might cost us under different scenarios.

Once teams set a policy of "we define our changes in git, and that's it", you can rely on a git history for change management.
This avoids drift in production environments and it also ensures that changes made in development environments make it into staging and then into production.
The days of *"it worked on my system, what's wrong with production?"* slowly fade away.

Less than ideal architectural decisions can also be adjusted over time to fit the applications being deployed.
Did you set up a network incorrectly?
Did you choose an instance type without enough RAM?

That's okay!

Just adjust the deployment in git, test it in staging, and push it to production.

# Cloud offers managed services

One thing I tell people constantly is that if you bend the cloud to fit your application, **you will almost always pay more.**
You get cost and performance efficiencies if you bend your application to fit the cloud.
Confused?
I'll explain.

When I talk to people doing their first cloud deployments, they deploy everything into VMs, much as they would in a local virtualized environment.

* _You need a database server?_
  Make a couple of VMs and set up replication.
* _You need to run a batch job via cron?_
  Deploy a VM and add it to the crontab.
* _You need a server to export an NFS share?_
  Deploy a VM with lots of storage and export it to other instances.

Do you see a pattern here?

![too-much.gif](too-much.gif)

Most public clouds offer tons of services that lift the management burden from engineering teams and offload into a managed service.
For example, that cron job might be able to move into a "serverless"[^serverless] service, such as [AWS Lambda](https://aws.amazon.com/lambda/).
It's critical to check the pricing here to ensure you're not headed down a bad path, but you have one less VM to maintain, one less IPv4 address to pay for, and a greatly reduced risk of configuration drift.
That reduction in stress and risk might be worth any additional costs.

Deployment decisions become much easier and lower stress when you consume services offered by the provider.
There are those situations where deploying a whole VM is needed, but I've managed to avoid that for some of my team's recent deployments.

Our last deployment uses GitHub Actions, S3, and CloudFront and costs us about $6.50 per month to run.
There are no virtual machines.
There's nothing to patch.

This blog [runs on a similar stack](/p/cloudfront-migration/) and costs me about $0.25 per month to run.

# Cloud offers geographic distribution

Nearly every public cloud, even the smallest ones, offer you the same or similar services in a wide variety of geographic regions.
Disaster recovery feels more attainable when you can easily deploy to multiple regions with the same software-defined infrastructure.

Data sovereignty continues to grow in importance around the world as more countries demand that their data remains within their borders.
As long as your cloud offers a region in that country, you can deploy there.
There's no challenging legal issues with finding datacenter space or getting hardware delivered.
You just change your region and deploy.

Cloud regions also allow you to bring your applications much closer to the people who use them.
Reduced latency delivers content faster to customers and provides a responsive experience.

# Clouds offer purchasing efficiency

**Wait a minute!**
Didn't I say that moving to cloud isn't just a purchasing exercise? 🤔

![surprise.gif](surprise.gif)

Your move to cloud should not be solely based on cutting costs or making purchasing IT more efficient.
Most teams find that moving to cloud is more expensive than they anticipated because they're finally able to get access to the right amount of resources that they need.
_(Also, they usually go with some more expensive options up front until they figure out how to optimize for cost.)_

First off, it's much easier to budget and pay one vendor for multiple services than deal with multiple independent vendors.
Instead of paying for datacenter space, then paying for servers, then paying for network equipment, then paying for people to set it up, and so on, you pay the cloud provider for all of it.

This also extends to other purchases on the cloud, such as products from certain vendors.
For example, you can buy Red Hat products directly from some cloud providers and that gets added onto your cloud invoice.
You can even deploy your own [Cisco ASA in the cloud](https://aws.amazon.com/marketplace/pp/prodview-sltshxd3bzqbg) if you feel so inclined.

With all of these purchases going through one vendor, you can also negotiate discounts if you set a spending commitment.
Discounts depend on your committed spend, of course, and the term that you agree to spend it.
There's a whole industry around financial operations in the cloud, called [FinOps](https://www.finops.org/introduction/what-is-finops/), and this is one of many things that factors into it.

# Wrapping up

Public clouds offer an incredible amount of opportunity to get your IT deployments into better shape with better change control and a solid software-defined workflow.
They also offer the ability to "write one check" to consume infrastructure via utility billing.

**However, public clouds are not ideal for every application or situation.**

Do I think that **every company** in the world could benefit from getting some part of their IT deployments into a public cloud platform?
**Yes, I do.**

Would **every company** benefit from putting most of their infrastructure into public clouds?
**Very unlikely.**

Some applications still benefit from being on purpose-built hardware or in certain locations where a cloud might not exist today.
Clouds can also be extremely expensive if you run large workloads around the clock.
They can also be painful for applications with very strict or special requirements that don't fit a cloud deployment model well.

The vendors that will succeed the most in the cloud space are the ones that look beyond purchasing efficiencies and IT acquisition concerns.
Simply dragging the old world of physical servers or virtual machines into cloud won't lead anywhere.

Those companies that help their customers **benefit from the best of what public clouds have to offer** in the most secure, reliable, and simple ways will be in the driver's seat.

[^quagmire]: A quagmire is something that gets worse no matter how you try to improve it.
  The only way to win is to avoid it entirely.
[^serverless]: Boy, I still dislike that _serverless_ term so much. 🤦‍♂️