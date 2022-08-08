---
title: Automated Let’s Encrypt DNS challenges with Rackspace Cloud DNS
author: Major Hayden
date: 2016-03-31T19:39:50+00:00
url: /2016/03/31/automated-lets-encrypt-dns-challenges-with-rackspace-cloud-dns/
dsq_thread_id:
  - 4709461797
tags:
  - ansible
  - bash
  - development
  - dns
  - networking
  - python
  - security
  - ssl
  - web

---
![gears_photo]

[Let's Encrypt][1] has taken the world by storm by providing free SSL certificates that can be renewed via automated methods. They have issued [over 1.4 million certificates][2] since launch in the fall of 2015.

If you are not familiar with how Let's Encrypt operates, here is an _extremely_ simple explanation:

  1. Create a private key
  2. Make a request for a new certificate
  3. Complete the challenge process
  4. You have a certificate!

That is highly simplified, but there is [plenty of detail available][3] on how the whole system works.

One of the most popular challenge methods is HTTP. That involves getting a challenge string from Let's Encrypt, placing the string at a known URL on your domain, and then waiting for verification of the challenge. The process is quick and Let's Encrypt [provides tools][4] that automate much of the process for you.

## A challenger appears

A DNS challenge is available in addition to the HTTP challenge. As you might imagine, this involves creating a DNS record with a string provided by Let's Encrypt. Once the DNS record is in place, it is verified and certificates are issued. The process goes something like this:

  1. Request a new certificate
  2. Get a challenge string
  3. Add a DNS TXT record on your domain with the challenge string as the data
  4. Wait for DNS records to appear on your DNS server
  5. Let's Encrypt checks for the DNS record
  6. Clean up the DNS record
  7. Get a certificate

Wrapping automation around this method is often easier than using the HTTP method since it does not require any changes on web servers. If someone has 500 web servers but they change their DNS records through a single API with a DNS provider, it quickly becomes apparent that adding a single DNS record is much easier.

In addition, the HTTP challenge method creates problems for websites which are not entirely publicly accessible yet. A stealth startup or a pre-release site could acquire a certificate without needing to allow any access into the webserver. This is also helpful for sites which will never be public facing, such as those on intranets.

## Automating the process

After some research, I stumbled upon a project in GitHub called [letsencrypt.sh][5]. The project consists of a bash script that makes all the necessary requests to Let's Encrypt's API for requesting and obtaining SSL certificates. However, DNS records are tricky since they are usually managed via an API or other non-trivial methods.

The project provides a hook feature which allows anyone to write a script that receives data and does the necessary DNS adjustments to complete the challenge process. I wrote a hook that interfaces with [Rackspace's Cloud DNS API][6] and handles the creation of DNS records:

  * [GitHub: letsencrypt-rackspace-hook][7]

All of the installation and configuration instructions are in the [main README file][8] within the repository. You can begin issuing certificates with DNS challenges in a few minutes.

The hook works like this:

  1. letsencrypt.sh hands off the domain name and a challenge string to the hook
  2. The hook adds a DNS record to Rackspace's DNS servers via the API
  3. The hook keeps checking to see if the DNS record is publicly accessible
  4. Once the DNS record appears, control is handed back to letsencrypt.sh
  5. letsencrypt.sh tells Let's Encrypt to verify the challenge
  6. Let's Encrypt verifies the challenge
  7. The hook cleans up the DNS record and displays the paths to the new certificates and keys.

From there, you can configure your configuration management software to push out the new certificate and keys to your production servers. Let's Encrypt certificates are currently limited to a 90-day duration, so be sure to configure this automation via a cron job. At the very least, set a calendar reminder for yourself a week or two in advance of the expiration.

Keep in mind that Let's Encrypt and Rackspace's DNS service are completely free. Free is a good thing.

Let me know what you think of the script! Feel free to make pull requests or issues if you find bugs. I am still working on some automated testing for the script and I hope to have that available in the next week or two.

_Photo Credit: [Aphernai][9] via [Compfight][10] [cc][11]_

 [1]: https://letsencrypt.org/
 [2]: https://letsencrypt.org/stats/
 [3]: https://letsencrypt.org/how-it-works/
 [4]: https://letsencrypt.org/getting-started/
 [5]: https://github.com/lukas2511/letsencrypt.sh
 [6]: https://www.rackspace.com/en-us/cloud/dns
 [7]: https://github.com/major/letsencrypt-rackspace-hook
 [8]: https://github.com/major/letsencrypt-rackspace-hook/blob/master/README.rst
 [9]: https://www.flickr.com/photos/137399762@N06/25476786513/
 [10]: http://compfight.com
 [11]: https://creativecommons.org/licenses/by-nc-sa/2.0/
 [gears_photo]: /wp-content/uploads/2016/03/25476786513_393afd0d2f_b-e1459452983901.jpg
