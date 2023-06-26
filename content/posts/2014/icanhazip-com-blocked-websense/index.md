---
aliases:
- /2014/08/06/icanhazip-com-blocked-websense/
author: Major Hayden
date: 2014-08-07 01:16:54
tags:
- icanhazip
- security
title: icanhazip.com blocked by Websense
---

_**UPDATE 2014-08-07:** Websense emailed me to say that the site has been reviewed and found to be safe. It may take some time for all of their products to receive the updated classification._

* * *

Quite a few emails and IRC messages hit my screen today about [icanhazip.com][1] being blocked by Websense products. The report on Websense's site claims shows that the site is part of a bot network: _The URL analyzed is currently compromised to serve malicious content to visitors._

Here are some screenshots from the report:

[<img src="/wp-content/uploads/2014/08/icanhazip-websense-01.png" alt="icanhazip blocked by websense" width="471" height="136" class="aligncenter size-full wp-image-5105" srcset="/wp-content/uploads/2014/08/icanhazip-websense-01.png 471w, /wp-content/uploads/2014/08/icanhazip-websense-01-300x86.png 300w" sizes="(max-width: 471px) 100vw, 471px" />][3]

[<img src="/wp-content/uploads/2014/08/icanhazip-websense-02.png" alt="icanhazip blocked by websense" width="603" height="184" class="aligncenter size-full wp-image-5106" srcset="/wp-content/uploads/2014/08/icanhazip-websense-02.png 603w, /wp-content/uploads/2014/08/icanhazip-websense-02-300x91.png 300w" sizes="(max-width: 603px) 100vw, 603px" />][4]

I reached out to Websense on Twitter and via their site. In the report I sent to them, I explained how the site works, gave them a link to the FAQ, and directed them to several blog posts from this site about icanhazip.com. This response from Websense hit my inbox late today:

> Hello,
>
> The site you submitted has been reviewed and determined to pose security risk. At this time, the site is not safe for browsing and is appropriately classified under the following category:
>
> hxxp://icanhazip.com/ - Bot Networks
>
> Researcher Notes: according to our findings, this site in question is embedded with Dyzap campaign malware.
>
> For additional details related to this threat, please refer to the following source: <https://www.bluecoat.com/security-blog/2014-08-01/dyzap-campaign-employs-freshly-minted-domains-and-other-tricks>
>
> The site will resume its content-based categorization, once it has been determined to no longer be a security risk.
>
> For further investigation, please contact the website administrator.
>
> If you have any questions and/or need any additional information, please let us know.
>
> Thank you for your inquiry,
>
> Lorna

> Websense Labs

Here's what I know:

  * The application that serves up the icanhazip services **is not compromised**
  * The virtual machine on which the application resides **is not compromised**
  * The application is returning valid data with **no evidence of serving malware**

If Websense wishes to claim that the site is being used by malware, I can certainly believe that. However, if they claim the site is serving malicious content or actively participating in attacks in any way, I've found no evidence that supports that claim.

I'll be reaching out to Websense again for additional details and to clear up the report listing on the website. If anyone knows of a way for me to identify this malware traffic and block it from accessing icanhazip.com, please let me know. My GPG key is [available][5].

 [1]: /icanhazip-com-faq/ "icanhazip.com FAQ"
 [3]: /wp-content/uploads/2014/08/icanhazip-websense-01.png
 [4]: /wp-content/uploads/2014/08/icanhazip-websense-02.png
 [5]: https://pgp.mit.edu/pks/lookup?op=get&search=0x9653FDDC6DC99178