---
title: 'DNS Service Review: Luadns'
author: Major Hayden
date: 2012-07-22T20:31:16+00:00
url: /2012/07/22/dns-service-review-luadns/
dsq_thread_id:
  - 3648134867
tags:
  - dns
  - git
  - lua
  - review
  - scripting
  - sysadmin

---
Vitalie Cherpec contacted me back in May about his new hosted DNS offering, [Luadns][1]. I gave it a try and I offered to write a review about the service.

[<img src="/wp-content/uploads/2012/07/luadns.png" alt="Luadns Logo" title="Luadns Logo" width="171" height="47" class="alignright size-full wp-image-3646" />][2]**DISCLAIMER:** I don't write many reviews on this blog, but I want to make sure a few things are clear. Vitalie was kind enough to set up an account for me to test with which would have normally cost me $9/month. However, he didn't give me any compensation of any kind for the review itself and there was nothing done for me outside of what a customer would receive at a paid service level at Luadns. **In other words, this is an honest review and I haven't been paid for a favorable (or unfavorable) response.**

At first glance, Luadns looks like many of the other hosted DNS services out there. Their DNS servers run [tinydns][3] and there are globally distributed DNS servers in Germany (Hetzner), California (Linode), New Jersey (Linode), Netherlands (LeaseWeb), and Japan (KDDI). The latency to the two US locations were reasonable from my home in San Antonio (on Time Warner Cable, usually under 70ms) but the overseas servers had reasonable latency except for the server in Germany. I was regularly seeing round trip times of over 300ms to that server.

What makes Luadns unique is [how you update][4] your DNS records. You can put your DNS zone files into a git repository in [GitHub][5] or [BitBucket][6] and then set up a post-commit hook to nudge Luadns when you make an update. This process gives you a good audit trail of when DNS changes were made, who changed them, and what was changed.

As soon as you push your changes, Luadns is notified and they can go about updating the DNS records on their servers around the world. You also get the option to do manual updates if your business processes require a thorough review of DNS changes prior to their public release. You'll receive an email confirmation each time Luadns is nudged with changes to your zone files.

In my experience, I saw pretty reasonable delays for updates. Here are the times I measured for DNS changes to propagate to all five Luadns servers:

  * Updates to an existing zone: 15-25 seconds (regardless of the amount of updates)
  * Adding a totally new zone: 30-45 seconds
  * Deleting a zone: 5-6 minutes (see following paragraph)

I contacted Vitalie about the long delay in deleting entire zones from Luadns and he made some adjustments to the domain deletion priority. After his change, deletions were processed in under 20 seconds every time I tried it.

All of my testing was done with basic BIND zone files but Luadns allows you to [write your zones in Lua][7] if you prefer. That allows you to do some pretty slick automation with templates and you won't have to be quite so repetitive as you normally would with BIND zone files.

**Summary**

Luadns provides a nice twist on the available DNS hosting solutions available today. Committing zone changes into a git repository allows for some great auditing and opens the door for pull requests that get a look from another team member before the DNS changes are released. The GitHub and Bitbucket integration is well done and the post-commit hooks seemed to work every time I tried them. The delays for zone updates are very reasonable and the pricing seems fair. I operate 48 domains and my bill each month would probably be $19 for the base plan. I'd easily go over the 4M queries/month so I'd expect to be paying extra.

I'd like to see Luadns improve by getting a more reliable European location that Hetzner since I can't get good round trip times from various locations that I've tried. Anycasted DNS servers would be a big plus, but that's a tough thing for a small company to do. I'd also like to see other development languages available other than Lua (python and ruby, perhaps).

Overall, I'd recommend Luadns for DNS hosting due to the convenience provided by GitHub/Bitbucket and the audit trail provided by both. Vitalie was easy to work with and he was quick to respond to any inquiry I sent. There's a free pricing tier - why not [give it a try][8]?

 [1]: http://www.luadns.com/
 [2]: /wp-content/uploads/2012/07/luadns.png
 [3]: http://en.wikipedia.org/wiki/Djbdns
 [4]: http://www.luadns.com/how.html
 [5]: http://github.com
 [6]: https://bitbucket.org/
 [7]: http://www.luadns.com/help.html#toc_9
 [8]: http://www.luadns.com/pricing.html
