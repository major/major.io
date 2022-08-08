---
title: Monitoring and protecting your reputation online
author: Major Hayden
date: 2012-08-06T14:00:50+00:00
url: /2012/08/06/monitoring-and-protecting-your-reputation-online/
dsq_thread_id:
  - 3642807052
tags:
  - general advice
  - security
  - sysadmin

---
After a [recent issue I had with some users in the Puppy Linux forums][1], I thought it might be prudent to write a post about how to monitor and protect your reputation online. This guide is mainly geared towards technical people who maintain some type of public presence. That should include folks who talk at conferences, contribute to high profile open source projects, or those who utilize social media to connect with other users and contributors.

The first part is monitoring. A monitoring solution should ideally be inexpensive, have a low lag time between a new mention and a notification, and it should be able to search a lot of resources.

For me, it made sense to use [Google Alerts][2]. I have as-it-happens searches in place for several things:

  * my full name
  * frequently used handles/usernames on various communication mediums (like IRC, twitter, etc)
  * the URL's of web sites I maintain
  * new links to web sites I maintain

Google Alerts allow me to get notifications very quickly about new blog posts, forum posts, or other websites which mention something I find to be sensitive. The signal to noise ratio for my searches is quite good but it has taken some time to hone the queries down and reduce the useless notifications.

If you frequent certain IRC channels, you ought to consider setting up an IRC bouncer if the server administrators allow it. You'll have the benefit of getting all of the logs from the channel even when you're not actively at your computer and you may be able to spot things that need attention.

Protecting your reputation is multi-faceted and immensely critical. The same communication mediums that you depend upon to spread your message and meet other people can be used against you in an instant. How many times have you seen hacked Twitter and Facebook accounts and then wondered: "I never would have thought someone would have targeted that person. I also figured that they would have protected their account a little more aggressively."

I've seen people with giant piles of alphabet soup (certifications) after their name (including CSO, CISSP, Security+) have their Twitter accounts hacked and I've had to tell them about it. It can happen to anyone but it's up to you to make it extremely difficult for it to happen. Here are some tips which apply specifically to Twitter but could be loosely applied to almost anything you use daily:

  * use very strong passwords along with a solid password manager
  * regularly audit the applications which have access to your account (via OAuth, API's, etc)
  * for critical accounts, force yourself to change the password regularly

If you don't get anything from this post, please understand this. **The most critical piece of your personal infrastructure to protect is your email account.** Think about it - where do your password resets go? Where do your domain name renewal notifications go? It's the crux of your personal security. Even if you have a 100-character password with upper/lower-case letters, numbers, symbols and unicode characters, you're totally unprotected when an attacker forces a password reset email and finds that your email account password is "p455w0rd".

For those providers that offer two-factor authentication, you really should consider using it. The pain of two-factor auth may be annoying at first, but imagine the pain when you find your bank account emptied, credit card filled, iPhone/iPad/laptop wiped and your personal identification information stolen.

I'll wrap up this post by talking about what I mentioned at the start of this post: responding to someone who has dragged your name through the mud on false information. Respond promptly and succinctly. Let them know who you are (with proof via links or other means), that their statements are false, and then provide proof and redirection. You certainly don't want to be overly agressive and condescending, but you don't want to be passive about it either. Be assertive and protect what's yours.

My grade school journalism teacher summed it up pretty well (I'll paraphrase):

> Your credibility and reputation are the two best things you've got. Money and fame will come and go but you'll always land on your feet if you keep your credibility. Your greatest asset is something that nobody else will help you protect.

 [1]: /2012/08/04/privacy-and-icanhazip-com/
 [2]: http://www.google.com/alerts
