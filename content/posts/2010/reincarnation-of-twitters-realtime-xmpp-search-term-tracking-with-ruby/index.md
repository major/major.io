---
aktt_notify_twitter:
- false
aliases:
- /2010/06/17/reincarnation-of-twitters-realtime-xmpp-search-term-tracking-with-ruby/
author: Major Hayden
date: 2010-06-17 18:40:48
dsq_thread_id:
- 3678950044
tags:
- command line
- jabber
- ruby
- scripts
- twitter
- xmpp
title: Reincarnation of Twitter’s realtime XMPP search term tracking with ruby
---

When Twitter was still in its early stages, you could track certain search terms in near-realtime [via Jabber][1]. It was quite popular and its performance degraded over time as more users signed up and began posting updates. Eventually, Twitter killed the jabber bot altogether. [Many users have asked when it will return][2].

Well, it hasn't returned, but you can build your own replacement with ruby, a jabber account, and a few gems. While it won't do everything that the original jabber bot did, you can still track tweets mentioning certain terms very quickly.

Here's how to get started:

First, install the _tweetstream_ and _xmpp4r-simple_ gems:

<pre lang="html">gem install tweetstream xmpp4r-simple</pre>

Next, you'll need a jabber account. You'll probably want to make one for the exclusive use of your jabber bot. I chose to make up a quick account at [ChatMask][3] for mine.

The last step is to drop a copy of this script on your server:

<pre lang="ruby">#!/usr/bin/ruby
require 'rubygems'
require 'tweetstream/client'
require 'tweetstream/hash'
require 'tweetstream/status'
require 'tweetstream/user'
require 'tweetstream/daemon'
require 'xmpp4r-simple'

jabber = Jabber::Simple.new('jabberbot@yourjabberserver.com','jabberpassword')

tweets = TweetStream::Client.new(twitterusername,twitterpassword)

tweets.track('celtics','lakers','finals','nba') do |status, client|
  imtext = "#{status.user.screen_name}: #{status.text} \r\n"
  imtext += "[http://twitter.com/#{status.user.screen_name}/status/#{status.id}]"
  jabber.deliver("yourjabberusername@yourjabberserver.com",imtext)
end

jabber.disconnect</pre>

You'll want to be sure to fill in the following:

  * your jabber bot's username and password
  * the username and password for the twitter account that will monitor the stream
  * the search terms you want to track
  * the destination jabber account where the messages should be sent

Ensure that your jabber account has authorized the jabber bot's account so that you'll actually receive the messages. Also, Twitter is [very strict with their streaming API tracking terms][4]. It's a good idea to review their [entire Streaming API documentation][5] to ensure that you're not going to end up having your account temporarily or permanently blacklisted.

Once everything is ready to go, you can just run the script within GNU screen or via nohup. There's still a bit more error checking to do around jabber reconnections, but the script has run non-stop for well over two weeks at a time without a failure.

 [1]: http://blog.twitter.com/2006/10/use-twitter-by-instant-message.html
 [2]: http://www.lagesse.org/twitter-and-track/
 [3]: http://www.chatmask.com/
 [4]: http://apiwiki.twitter.com/Streaming-API-Documentation#FilterLimiting
 [5]: http://apiwiki.twitter.com/Streaming-API-Documentation