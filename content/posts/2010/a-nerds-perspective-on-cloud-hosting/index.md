---
aliases:
- /2010/08/25/a-nerds-perspective-on-cloud-hosting/
author: Major Hayden
date: 2010-08-25 13:03:52
tags:
- advice
- cloud
- hosting
- opinion
- sysadmin
title: A nerd’s perspective on cloud hosting
---

Let's go ahead and get this out of the way: <b style="color: #D42020;">The following post contains only my personal opinions. These are not the opinions of my employer and should not be considered as such.</b>

* * *

The term "cloud hosting" has become more popular over the past few years and it seems like everyone is talking about it. I'm often asked by customers and coworkers about what cloud hosting really is. Where does traditional dedicated hosting end and cloud begin? Do they overlap? Who needs cloud and who doesn't?</p>

You can't talk about cloud hosting without defining it first. When I think of "cloud", these are the things that come to mind:

* quickly add/remove resources with little or no lead time
* hosting platforms that allow for quick provisioning of highly available systems
* self-service adjustment of tangible and intangible resources that normally require human intervention

That list may seem a bit vague at first, but try to let it sink in just a bit. Hosting applications in a "cloud" shouldn't mean that you must have a virtual instance running on Xen, KVM or VMWare, and it shouldn't mean that you must have an account with Rackspace Cloud, Amazon EC2, or Microsoft Azure. It means that your hosting operations are highly automated and you can rapidly allocate and deallocate resources for the requirements of your current projects.

Consider this: a customer of a traditional dedicated hosting provider decides to take their applications and host them on one VPS at a leading commercial provider. That provider allows the customer to spin up new VM's in a matter of minutes and re-image the VM's whenever they like. Is that cloud hosting? **I'd say yes - even if it's one single virtual instance.** That customer has moved from a hosting system with manual interventions and extended lead times to a system where they have instant control over their resources.

It's not possible to talk about what cloud is without talking about what it isn't.

  * **Cloud is not infinitely scalable.** If any provider ever claims that their solution is "infinitely scalable", you should be skeptical. Regardless of the provider, everyone eventually runs out of datacenter space, servers, network bandwidth, or power. (If you know of a provider that is infinitely scalable, please let me know as I'd love to see their facilities and review their supply chain.)
  * **Cloud isn't right for everybody.** Some applications have demands that cloud hosting might not be able to meet (yet). If an application depends on proprietary hardware that is difficult to virtualize or rapidly allocate, cloud hosting is probably not the answer for that particular application.
  * **Cloud doesn't mean VPS. VPS doesn't mean cloud.** As I said before, having a virtual private server environment is not a pre-requisite for cloud hosting. Also, not all VPS solutions fit my definition of cloud as they don't allow for rapid deployments and resource adjustments.

It's important to remember that cloud hosting is a marketing term. As for the technology of cloud, it's what you make of it. You should be looking to reduce costs, solidify availability and increase performance every day. If the ideals of cloud hosting help you do that, it might be the right option for you.