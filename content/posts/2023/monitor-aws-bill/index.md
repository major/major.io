---
author: Major Hayden
date: '2023-03-02'
summary: |
  Nobody likes a surprise bill. Learn some ways to keep your AWS bill under control and
  avoid that end of the month panic. 😱
tags:
  - aws
  - cloud
  - cost
title: Monitor your AWS bill
coverAlt: Tall waterfall with a huge splash at the bottom that is making lots of fog
coverCaption: |
  [Stephen Walker](https://unsplash.com/photos/onIXxjH56AA)
---

Public clouds are the all-you-can-eat buffet of infrastructure.
Nearly any IT problem can be solved in minutes with a few clicks or API requests.

**This is not your average buffet.**

Every item at the buffet comes with a cost.
Many of these costs are difficult to understand.
Even if you do understand them, estimating your potential usage of these services is challenging.

Most services are pay-per-use where you pay based on the time used or the amount used.
Other charges are one-time costs that get billed immediately.

Some pricing, like object storage, looks totally straightforward at first glance.
Then you find millions upon millions of half penny charges that add up to real money.

Then there's the situation that angers me the most: 
charges for infrastructure you deployed and forgot to clean up!

How do we tackle this problem?
Let's get right to it.

# Set a budget

AWS allows you to set a budget and get alarms when you've consumed part of your budget or exceeded it entirely.
This is a great way to catch unexpected charges.
It also helps you find forgotten deployments.

Head on over to the [AWS Billing Dashboard](https://us-east-1.console.aws.amazon.com/billing/home) first.
Look for [Budgets](https://us-east-1.console.aws.amazon.com/billing/home?region=us-east-1#/budgets/overview) on the left navigation menu and click it.

Once you click **Create a Budget**, you get a few handy options:

1. Choose the **Zero spend budget** if you plan to stay on the free tier.
   You get alerts when your bill crosses $0.01.
2. Choose the **Monthly cost budget** to set your own budget.

I use a little more than what the free tier offers on some services, so I go for the monthly cost budget.
Choose a budget amount and add some email recipients to be notified.

As of this post's writing, AWS will send you notifications under three different conditions:

1. You used > 85% of your budget.
2. You used 100% of your budget.
3. Your _forecasted spend_ is expected to cross your budget limit.

Keep a close watch for the forecasted spend emails.
These are usually the earliest warning that you're potentially in danger of exceeding your budget.

Monitor your inbox closely for these emails.

# Analyzing your spend

AWS offers some tools for analyzing your cloud spend and these can give you clues to investigate.
Start by going to [AWS Cost Management](https://us-east-1.console.aws.amazon.com/cost-management/home#/dashboard) and clicking on **Cost Explorer** on the left side.

Look for **Group by** on the right and choose **Service** from the drop down.
The chart and table provided should help you see which service is running up charges.

In my situation, I had a lot of charges from S3 that I didn't expect.
The bar chart showed a big jump in S3 expenses.
I broke down the expenses by choosing two new options on the right side:

1. Click **Usage type** in the **Group by** drop down.
2. Choose **S3 (Simple Storage Service)** from the **Service** drop down.

My actual storage consumption costs were quite low, but my tier 1 and 2 requests increased massively.
I began sifting through my scripts that do things in S3.
There was one that was poorly written that was downloading larger and larger amounts of data from S3 frequently.
**These increased request counts caused my bill to increase by 4x!**

# Remember the forgotten

As I mentioned earlier, one of the most painful situations involves big charges for infrastructure that you forgot about.
Perhaps it's an EC2 instance you spun up for testing.
Maybe it's a Lambda you tried and forgot about.
Perhaps you provisioned a NAT gateway _(ultimate pain)_.

Monitoring your budgets will help a lot with forgotten infrastructure, but you only find out _after_ your bill increased.

Most of my mistakes happen with EC2-related infrastructure such as instances, volumes, or snapshots.
EC2 is a region-specific service, though.
Who wants to go through their EC2 infrastructure region by region?

Luckily, AWS provides the [EC2 Global View](https://us-east-1.console.aws.amazon.com/ec2globalview/home?region=us-east-1#).
You get a look across all of your EC2 infrastructure in all regions to get counds of instances, networks, volumes, and auto scaling groups.
This page helped me find some forgotten snapshots that kept dinging me with small bills each month.

Another option is to provision infrastructure with [terraform](https://www.terraform.io/).
Terraform allows you to specify your cloud infrastructure in code.
From there, you can build it (`terraform apply`) and tear it down (`terraform destroy`) easily.

Anything that you build with terraform is easily destroyed.
**Destroyed completely.**
If terraform can't clean up your infrastructure for some reason, it notifies you about the resources it could not delete.

# Plan ahead for costs

Storing your terraform code in a GitHub repository allows you to make pull requests for changes and see what will change.
You can [run terraform via GitHub Actions](https://developer.hashicorp.com/terraform/tutorials/automation/github-actions).

Once you have that running, consider adding [Infracost](https://www.infracost.io/) to your repository.
Infracost analyzes each pull request and explains the billing changes based on what you're deploying (or destroying).
It replies in the PR with a comment detailing the potential charges that your change might incur.

This is a great way to avoid really painful charges (like the $600 dedicated IP charge for CloudFront) and track your cloud infrastructure costs over time.