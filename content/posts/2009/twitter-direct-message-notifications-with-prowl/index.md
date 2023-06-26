---
aliases:
- /2009/09/19/twitter-direct-message-notifications-with-prowl/
author: Major Hayden
date: 2009-09-19 17:48:27
title: Twitter direct message notifications with Prowl
---

If you want instant notifications of a direct message on Twitter on your iPhone, you have a few options. You could set up your mobile device to receive SMS messages and get them quickly, but you're stuck paying for all of those incoming SMS messages. However, it's annoying when you follow an account, and then they follow and DM you at 4AM. Twitter [allows you to set quiet hours][1], but then you don't see any notifications on your phone when you wake up.

You could always pick up Boxcar [[iTunes Link][2]] from iTunes and use it's plug-and-play setup routine to begin receiving notifications of direct messages. The downside of the app is that the notifications are fairly delayed (sometimes 5-10 minutes late in my experience) and you're paying $2.99 for an app that can only handle one Twitter account. Also, the app only handles Twitter direct messages and replies &#8211; nothing else.

Here's where Prowl [[iTunes Link][3]] comes in. You can toss anything at the [Prowl API][4] and it comes up on your phone within seconds. The app is $2.99, but you can sent up to 1,000 notifications per hour through the API at no additional cost. **Seriously &#8211; would you ever need 1,000 notifications per hour?**

First, you'll need two ruby gems for this project. The first of which is the [prowl][5] gem by [August Lilleaas][6], and the second is [tmail][7]. If you haven't installed gems from github before, you'll need to run this first:

<pre lang="html">gem sources -a http://gems.github.com</pre>

Install the gems:

<pre lang="html">gem install prowl tmail</pre>

Once they're installed, you can toss this script into `/usr/local/bin/twitterdm-prowl.rb`:

<pre lang="ruby">#!/usr/bin/env ruby
require 'rubygems'
require 'tmail'
require 'prowl'

message = $stdin.read
mail = TMail::Mail.parse(message)

prowlevent = mail.subject.gsub(/Direct message from /,'').strip
prowlbody = mail.parts[0].body.split(/\n\n/)[0].strip

Prowl.add('your-prowl-api-key-goes-here', {
  :application => "TWITDM",
  :event => prowlevent,
  :description => prowlbody,
  :priority => 0,
})</pre>

At the beginning of the script, we rope in rubygems, tmail and prowl. We're going to read a message in from standard input (I'll show you how that works in a moment) and then parse it with tmail. The subject and body are stripped down to make it easier to display on your iPhone's screen. Finally, we wrap up by sending the data to the Prowl API with a normal priority.

As far as customizations go, you'll obviously need to input your Prowl API key for the script to work. You can adjust the regular expressions to include different parts of the e-mail if you need them. Also, feel free to adjust the application name (&#8220;TWITDM&#8221;) in the script to something else. The priority can run from 2 (OMG emergency) to -2 (I don't care). I chose 0 (normal) for my script.

Now, make sure the script is executable:

<pre lang="html">chmod 0755 /usr/local/bin/twitterdm-prowl.rb</pre>

We'll need to set up an alias in `/etc/aliases` to feed in this e-mails to our script:

<pre lang="html">twitterdm:	 "|/usr/bin/ruby /usr/local/bin/twitterdm-prowl.rb"</pre>

Run `newaliases` to ensure that your alias ends up in the hashed aliases table.

At this point, you'll need to ensure that your emails actually make it into the alias you set up. You'll need something that can filter your e-mails and forward them based on the filter. If you want a strictly Linux solution, you could use procmail for that. If you're e-mail provider has server-side filters that can forward e-mails ([as mine does][8]), that's the easiest method. Twitter provides some great e-mail headers that you can use for filtering:

<pre lang="html">X-Twittercreatedat: Sat Sep 19 17:26:31 +0000 2009
X-Twitterrecipientid: 14453057
X-Twitterrecipientscreenname: RackerHacker
X-Twitteremailtype: direct_message
X-Twitterdirectmessageid: 383469494
X-Twittersenderid: 25000734
X-Twittersendername: Major Hayden
X-Twittersenderscreenname: rkrhkr
X-Twitterrecipientname: Major Hayden</pre>

I use `X-Twitteremailtype: direct_message` to filter and forward, but it's up to you on how you do it.

Now, use another account to send yourself a direct message and you should get a notification pretty quickly (see the image on the right). If you didn't get a notification, try going to the Prowl site and [send yourself a test notification][9]. If the test notification fails, then you may have an issue with Prowl itself (this hasn't ever happened to me).

If the test notification works, but your Twitter notifications don't, check your mail logs. Your filters may not be sending the direct message e-mails to your alias, your alias may not be configured properly, or the permissions on the ruby script you made may be incorrect.

If you want to keep testing without sending yourself a ton of direct messages, just send yourself one direct message. Once you receive the e-mail notification from Twitter, open it up and view the source of the message in your e-mail client (command-option-U in Apple Mail). Copy the entire source of the message to your clipboard, paste it into your favorite text editor on your server, and save it. You can call your script with the e-mail just like your mail server would with the following:

<pre lang="html">cat "twitterdmmessage.txt" | /usr/local/bin/twitterdm-prowl.rb</pre>

By going that route, you be testing the script itself, and your e-mail server will be removed from the equation.

If you're still having trouble, let me know and I'll be glad to help!

 [1]: http://twitter.com/devices
 [2]: http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=321493542&mt=8
 [3]: http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=320876271&mt=8
 [4]: http://prowl.weks.net/api.php
 [5]: http://github.com/augustl/ruby-prowl
 [6]: http://github.com/augustl
 [7]: http://tmail.rubyforge.org/
 [8]: http://www.rackspace.com/email_hosting/
 [9]: https://prowl.weks.net/add_notification.php