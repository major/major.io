---
aliases:
- /2013/03/03/controlling-sensitive-company-data-means-losing-some-control-of-it/
author: Major Hayden
date: 2013-03-03 17:18:13
dsq_thread_id:
- 3678915271
tags:
- general advice
- security
title: Controlling sensitive company data means losing some control of it
---

This year's [RSA Conference][1] was full of very useful content but the most useful session for me was a peer to peer discussion regarding BYOD on mobile devices. The session had room for about 25 people and many companies were represented. Some companies were huge, household names, while others were very small.

The discussion started around how to authenticate and manage mobile devices, but it soon ended up covering the handling of data on personal and company-issued devices. A corporate security leader for a large company said the healthiest shift for them was when they stopped focusing on the devices themselves and moved their focus to the data they wanted to protect. They found that they could lock down all the devices in the world, but their employees would mishandle the data no matter what actions they took to protect the endpoint.

That led me to start a ruckus on Twitter:

<blockquote class="twitter-tweet tw-align-center" width="500">
  <p>
    How does a corporate security team keep sensitive data out of products like Evernote and Dropbox effectively? It's a tall order.
  </p>

  <p>
    &mdash; Major Hayden (@majorhayden) <a href="https://twitter.com/majorhayden/statuses/307996527501119488">March 2, 2013</a>
  </p>
</blockquote>



Which I soon followed with this:

<blockquote class="twitter-tweet tw-align-center" width="500">
  <p>
    My last question got a lot of good responses. Thanks! But how do you *ENFORCE* a corporate policy against something like Dropbox/Evernote?
  </p>

  <p>
    &mdash; Major Hayden (@majorhayden) <a href="https://twitter.com/majorhayden/statuses/308045768265195521">March 3, 2013</a>
  </p>
</blockquote>



The responses started piling up in a hurry. _(To see the verbatim responses for yourself, click the date on one the embedded tweets above.)_ Here's a quick summary of the suggested ways to attack the problem from the tweets I received:

  * **Education & awareness** - Ensure that users not only understand where they should keep confidential data but also ensure they understand how to classify the data they're handling.
  * **Provide alternatives** - If users like the functionality of a particular product, try to purchase an enterprise version of the product or re-create the product internally. Users will be more likely to use the approved version of the product and the company will have a bit more control over the data.
  * **Top-down policies & enforcement** - Make policies that define where data can and cannot go and follow that up with enforcement and accountability.
  * **Deny access** - Set firewall or DLP policies to disallow access to certain products while on the corporate network. This doesn't cover situations where employees are off the corporate network.

Many people suggested a blend between educating, providing alternatives, and enforcement. This is a real change for corporate IT and security departments that would normally opt for denying access to unapproved applications entirely. This quickly turns into a game of cat-and-mouse in which there are no clear winners.

Take an example like Evernote. If I was blocked from accessing it at work, I could VPN into another location and send Evernote over the VPN. If VPN access was blocked, I could start an ssh proxy and send the Evernote traffic through it. If ssh was blocked, I could remotely access another system via RDP or VNC where Evernote was installed and use it there. The truly frustrated user might invest in a 3G/4G device and use that in the office instead. That's even worse for the security department since none of their traffic would be passing through the corporate network.

Here are my suggestions for protecting data at a modern company:

  1. **Listen to your users** - Find out why users like a particular third party application and why they don't like the current tools provided by the company. Learn about the types of data they're storing on that third party application.
  2. **Regain some control of your data through alternatives** - If your users prefer a particular application, try to purchase an enterprise or self-hosted version of the application. Your users will be pleased since they get the functionality they expect and the security teams can gain a little more control over the data stored in the application.
  3. **Make a solid data classification policy** - Creating an easy to use data classification policy is the first step to securing your data through awareness. Employees need to identify the sensitivity of the data they're handling before they can know what they can and can't do with it. Make the data classifications easy to identify and ensure that users have an escalation point they can use when they have questions or they need to release sensitive data.
  4. **Create enforcement policies** - If a user deliberately disobeys corporate policy, this where the rubber meets the road. Ensure that the policy is fair to users of various technical levels within the company and vet it thoroughly with your legal and HR departments. These enforcement policies may be required by various compliance programs, so check to see if they're on paper but not enforced.
  5. **Educate users about sensitive data** - Humanize your data classification policy and help users understand how to identify and handle sensitive data. Remind employees about the importance of company data and what can happen if it was misplaced or stolen. There will be a _significant_ amount of questions coming from this process so be sure that you're ready to tackle them. If you do this right, you'll get employees policing themselves and their peers.
  6. **Rinse and repeat** - Regularly check in with users to verify that the internal applications are meeting their needs. Go through the awareness work on a regular basis. When policies become dormant or ineffective, revise them to meet the current needs.

This problem isn't going away anytime soon and it's rapidly evolving. Your corporate security department must evolve with it. A coworker of mine hit the nail on the head with this:

<blockquote class="twitter-tweet tw-align-center" width="500">
  <p>
    <a href="https://twitter.com/rackerhacker">@rackerhacker</a> that's probably the number 1 security dilemma for the next two years.
  </p>

  <p>
    &mdash; letterj (@letterj) <a href="https://twitter.com/letterj/statuses/308040745527410688">March 3, 2013</a>
  </p>
</blockquote>



The best thing about this approach is that it scales better and is more effective than denying access. It takes a significant amount of work up front for a corporate security department, but it pays off in the end. Employees soon call out other employees for poor security hygiene and they become informal delegates of the corporate security team. Security can go viral in your organization just like the usage of third party tools.

**The key to success is driving security innovation within your company that equals or outpaces the innovation coming from third party applications.**

New tools and services may appear on a daily basis, but if your employees know what belongs there and what doesn't, they'll do your work for you.

 [1]: http://www.rsaconference.com/events/2013/usa/index.htm